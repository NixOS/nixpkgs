{ stdenv
, lib
, formats
, nixosTests
, rustPlatform
, fetchFromGitHub
, installShellFiles
, nix-update-script
, pkg-config
, udev
, openssl
, sqlite
, pam
, bashInteractive
, rust-jemalloc-sys
, kanidm
# If this is enabled, kanidm will be built with two patches allowing both
# oauth2 basic secrets and admin credentials to be provisioned.
# This is NOT officially supported (and will likely never be),
# see https://github.com/kanidm/kanidm/issues/1747.
# Please report any provisioning-related errors to
# https://github.com/oddlama/kanidm-provision/issues/ instead.
, enableSecretProvisioning ? false
}:

let
  arch = if stdenv.hostPlatform.isx86_64 then "x86_64" else "generic";
in
rustPlatform.buildRustPackage rec {
  pname = "kanidm";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-W5G7osV4du6w/BfyY9YrDzorcLNizRsoz70RMfO2AbY=";
  };

  cargoHash = "sha256-gJrzOK6vPPBgsQFkKrbMql00XSfKGjgpZhYJLTURxoI=";

  KANIDM_BUILD_PROFILE = "release_nixos_${arch}";

  patches = lib.optionals enableSecretProvisioning [
    ./patches/oauth2-basic-secret-modify.patch
    ./patches/recover-account.patch
  ];

  postPatch =
    let
      format = (formats.toml { }).generate "${KANIDM_BUILD_PROFILE}.toml";
      profile = {
        admin_bind_path = "/run/kanidmd/sock";
        cpu_flags = if stdenv.hostPlatform.isx86_64 then "x86_64_legacy" else "none";
        default_config_path = "/etc/kanidm/server.toml";
        default_unix_shell_path = "${lib.getBin bashInteractive}/bin/bash";
        htmx_ui_pkg_path = "@htmx_ui_pkg_path@";
        web_ui_pkg_path = "@web_ui_pkg_path@";
      };
    in
    ''
      cp ${format profile} libs/profiles/${KANIDM_BUILD_PROFILE}.toml
      substituteInPlace libs/profiles/${KANIDM_BUILD_PROFILE}.toml \
        --replace '@htmx_ui_pkg_path@' "${placeholder "out"}/ui/hpkg" \
        --replace '@web_ui_pkg_path@' "${placeholder "out"}/ui/pkg"
    '';

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    udev
    openssl
    sqlite
    pam
    rust-jemalloc-sys
  ];

  # The UI needs to be in place before the tests are run.
  postBuild = ''
    # We don't compile the wasm-part form source, as there isn't a rustc for
    # wasm32-unknown-unknown in nixpkgs yet.
    mkdir -p $out/ui
    cp -r server/web_ui/pkg $out/ui/pkg
    cp -r server/core/static $out/ui/hpkg
  '';

  # Otherwise build breaks on some unused code
  env.RUSTFLAGS = "-A dead_code";

  # Not sure what pathological case it hits when compiling tests with LTO,
  # but disabling it takes the total `cargo check` time from 40 minutes to
  # around 5 on a 16-core machine.
  cargoTestFlags = ["--config" ''profile.release.lto="off"''];

  preFixup = ''
    installShellCompletion \
      --bash $releaseDir/build/completions/*.bash \
      --zsh $releaseDir/build/completions/_*

    # PAM and NSS need fix library names
    mv $out/lib/libnss_kanidm.so $out/lib/libnss_kanidm.so.2
    mv $out/lib/libpam_kanidm.so $out/lib/pam_kanidm.so
  '';

  passthru = {
    tests = {
      inherit (nixosTests) kanidm kanidm-provisioning;
    };

    updateScript = nix-update-script {
      # avoid spurious releases and tags such as "debs"
      extraArgs = [
        "-vr"
        "v(.*)"
      ];
    };

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
    platforms = platforms.linux;
    maintainers = with maintainers; [ adamcstephens erictapen Flakebi ];
  };
}
