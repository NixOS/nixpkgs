{
  version,
  hash,
  cargoHash,
  unsupported ? false,
}:

{
  stdenv,
  lib,
  formats,
  nixosTests,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  pkg-config,
  udev,
  openssl,
  sqlite,
  pam,
  bashInteractive,
  rust-jemalloc-sys,
  kanidm,
  # If this is enabled, kanidm will be built with two patches allowing both
  # oauth2 basic secrets and admin credentials to be provisioned.
  # This is NOT officially supported (and will likely never be),
  # see https://github.com/kanidm/kanidm/issues/1747.
  # Please report any provisioning-related errors to
  # https://github.com/oddlama/kanidm-provision/issues/ instead.
  enableSecretProvisioning ? false,
}:

let
  arch = if stdenv.hostPlatform.isx86_64 then "x86_64" else "generic";

  versionUnderscored = builtins.replaceStrings [ "." ] [ "_" ] (
    lib.versions.majorMinor kanidm.version
  );

  provisionPatches = [
    (./. + "/provision-patches/${versionUnderscored}/oauth2-basic-secret-modify.patch")
    (./. + "/provision-patches/${versionUnderscored}/recover-account.patch")
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kanidm" + (lib.optionalString enableSecretProvisioning "-with-secret-provisioning");
  inherit version cargoHash;

  cargoDepsName = "kanidm";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    inherit hash;
  };

  env.KANIDM_BUILD_PROFILE = "release_nixpkgs_${arch}";

  patches = lib.optionals enableSecretProvisioning provisionPatches;

  postPatch =
    let
      format = (formats.toml { }).generate "${finalAttrs.env.KANIDM_BUILD_PROFILE}.toml";
      socket_path = if stdenv.hostPlatform.isLinux then "/run/kanidmd/sock" else "/var/run/kanidm.socket";
      profile = {
        cpu_flags = if stdenv.hostPlatform.isx86_64 then "x86_64_legacy" else "none";
      }
      // lib.optionalAttrs (lib.versionAtLeast version "1.5") {
        client_config_path = "/etc/kanidm/config";
        resolver_config_path = "/etc/kanidm/unixd";
        resolver_unix_shell_path = "${lib.getBin bashInteractive}/bin/bash";
        server_admin_bind_path = socket_path;
        server_config_path = "/etc/kanidm/server.toml";
        server_ui_pkg_path = "@htmx_ui_pkg_path@";
      };
    in
    ''
      cp ${format profile} libs/profiles/${finalAttrs.env.KANIDM_BUILD_PROFILE}.toml
      substituteInPlace libs/profiles/${finalAttrs.env.KANIDM_BUILD_PROFILE}.toml --replace-fail '@htmx_ui_pkg_path@' "$out/ui/hpkg"
    '';

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
    sqlite
    pam
    rust-jemalloc-sys
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ];

  # The UI needs to be in place before the tests are run.
  postBuild = ''
    mkdir -p $out/ui
    cp -r server/core/static $out/ui/hpkg
  '';

  # Upstream runs with the Rust equivalent of -Werror,
  # which breaks when we upgrade to new Rust before them.
  # Just allow warnings. It's fine, really.
  env.RUSTFLAGS = "--cap-lints warn";

  # Not sure what pathological case it hits when compiling tests with LTO,
  # but disabling it takes the total `cargo check` time from 40 minutes to
  # around 5 on a 16-core machine.
  cargoTestFlags = [
    "--config"
    ''profile.release.lto="off"''
  ];

  preFixup = ''
    installShellCompletion \
      --bash $releaseDir/build/completions/*.bash \
      --zsh $releaseDir/build/completions/_*
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    # PAM and NSS need fix library names
    mv $out/lib/libnss_kanidm.so $out/lib/libnss_kanidm.so.2
    mv $out/lib/libpam_kanidm.so $out/lib/pam_kanidm.so
  '';

  passthru = {
    tests = {
      inherit (nixosTests) kanidm kanidm-provisioning;
    };

    updateScript = lib.optionals (!enableSecretProvisioning) (nix-update-script {
      # avoid spurious releases and tags such as "debs"
      extraArgs = [
        "-vr"
        "v([0-9\\.]*)"
        "--override-filename"
        "pkgs/by-name/ka/kanidm/${versionUnderscored}.nix"
      ];
    });

    inherit enableSecretProvisioning;
    withSecretProvisioning = kanidm.override { enableSecretProvisioning = true; };
  };

  # can take over 4 hours on 2 cores and needs 16GB+ RAM
  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    changelog = "https://github.com/kanidm/kanidm/releases/tag/v${version}";
    description = "Simple, secure and fast identity management platform";
    homepage = "https://github.com/kanidm/kanidm";
    license = licenses.mpl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      adamcstephens
      Flakebi
    ];
    knownVulnerabilities = lib.optionals unsupported [
      ''
        kanidm ${version} has reached EOL.

        Please upgrade by verifying `kanidmd domain upgrade-check` and choosing the next version with `services.kanidm.package = pkgs.kanidm_1_x;`
        See upgrade guide at https://kanidm.github.io/kanidm/master/server_updates.html
      ''
    ];
  };
})
