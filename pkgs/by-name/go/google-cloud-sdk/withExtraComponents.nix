{
  lib,
  google-cloud-sdk,
  symlinkJoin,
  components,
}:

comps_:

let
  # Remove components which are already installed by default
  filterPreInstalled =
    let
      preInstalledComponents = with components; [
        bq
        bq-nix
        core
        core-nix
        gcloud-deps
        gcloud
        gsutil
        gsutil-nix
      ];
    in
    builtins.filter (drv: !(builtins.elem drv preInstalledComponents));

  # Recursively build a list of components with their dependencies
  # TODO this could be made faster, it checks the dependencies too many times
  findDepsRecursive = lib.converge (
    drvs: lib.unique (drvs ++ (builtins.concatMap (drv: drv.dependencies) drvs))
  );

  # Components to install by default
  defaultComponents = with components; [
    alpha
    beta
  ];

  comps = [
    google-cloud-sdk
  ]
  ++ filterPreInstalled (findDepsRecursive (defaultComponents ++ comps_));

  installCheck =
    let
      compNames = map lib.getName comps_;
    in
    ''
      $out/bin/gcloud components list --only-local-state --format 'value(id)' > component_list.txt
      for comp in ${toString compNames}; do
        snapshot_file="$out/google-cloud-sdk/.install/$comp.snapshot.json"

        if ! [ -f "$snapshot_file"  ]; then
          echo "Failed to install component '$comp'"
          exit 1
        fi

        if grep --quiet '"is_hidden":true' "$snapshot_file"; then
          continue
        fi

        if ! grep --quiet "^$comp$" component_list.txt; then
          echo "Failed to install component '$comp'"
          exit 1
        fi
      done
    '';
in
# The `gcloud` entrypoint script has some custom logic to determine the "real" cloud sdk
# root. In order to not trip up this logic and still have the symlink joined root we copy
# over this file. Since this file also has a Python wrapper, we need to copy that as well.
symlinkJoin {
  name = "google-cloud-sdk-${google-cloud-sdk.version}";
  inherit (google-cloud-sdk) meta;

  paths = [
    google-cloud-sdk
  ]
  ++ comps;

  postBuild = ''
    sed -i ';' $out/google-cloud-sdk/bin/.gcloud-wrapped
    sed -i -e "s#${google-cloud-sdk}#$out#" "$out/google-cloud-sdk/bin/gcloud"
    ${installCheck}
  '';
}
