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
}:

let
  arch = if stdenv.isx86_64 then "x86_64" else "generic";
in
rustPlatform.buildRustPackage rec {
  pname = "kanidm";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Clg9jQgKvWP9LniHmNq+WjRmEOzJGfuCU2K9ActZhzo=";
  };

  cargoHash = "sha256-m3H2mQm+k6vFH+nP+hWl07Z7NJKJlt1E4eRDRA2Z0+o=";

  KANIDM_BUILD_PROFILE = "release_nixos_${arch}";

  postPatch =
    let
      format = (formats.toml { }).generate "${KANIDM_BUILD_PROFILE}.toml";
      profile = {
        admin_bind_path = "/run/kanidmd/sock";
        cpu_flags = if stdenv.isx86_64 then "x86_64_legacy" else "none";
        default_config_path = "/etc/kanidm/server.toml";
        default_unix_shell_path = "${lib.getBin bashInteractive}/bin/bash";
        web_ui_pkg_path = "@web_ui_pkg_path@";
      };
    in
    ''
      cp ${format profile} libs/profiles/${KANIDM_BUILD_PROFILE}.toml
      substituteInPlace libs/profiles/${KANIDM_BUILD_PROFILE}.toml \
        --replace '@web_ui_pkg_path@' "${placeholder "out"}/ui"
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
    mkdir $out
    cp -r server/web_ui/pkg $out/ui
  '';

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
      inherit (nixosTests) kanidm;
    };

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    changelog = "https://github.com/kanidm/kanidm/releases/tag/v${version}";
    description = "A simple, secure and fast identity management platform";
    homepage = "https://github.com/kanidm/kanidm";
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ adamcstephens erictapen Flakebi ];
  };
}
