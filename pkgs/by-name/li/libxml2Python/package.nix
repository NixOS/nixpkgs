{
  buildEnv,
  libxml2,
  python3,
}:
let
  pythonLibxml2 = python3.pkgs.libxml2;
in
buildEnv {
  # slightly hacky
  name = "libxml2+py-${libxml2.version}";
  paths = with pythonLibxml2; [
    dev
    bin
    py
  ];
  # Avoid update.nix/tests conflicts with libxml2.
  passthru = removeAttrs pythonLibxml2.passthru [
    "updateScript"
    "tests"
  ];
  # the hook to find catalogs is hidden by buildEnv
  postBuild = ''
    mkdir "$out/nix-support"
    cp '${pythonLibxml2.dev}/nix-support/propagated-build-inputs' "$out/nix-support/"
  '';
}
