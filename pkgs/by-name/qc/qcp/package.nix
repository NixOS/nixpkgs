{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "qcp";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "crazyscot";
    repo = "qcp";
    tag = "v${version}";
    hash = "sha256-9nJ01OPAU60veLpL2BlSSUTMu/xdUBDVkV0YEFNQ3FU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vVlwhXaCumgwTcHjnGwD6mi+ZtZvqmtCWukQaPBQcsA=";

  postInstall = ''
    install -Dm644 $src/misc/qcp.1 $out/share/man/man1/qcp.1
    install -Dm644 $src/misc/qcp_config.5 $out/share/man/man5/qcp_config.5
    install -Dm644 $src/misc/20-qcp.conf $out/etc/sysctl.d/20-qcp.conf
    install -Dm644 $src/misc/qcp.conf $out/etc/qcp.conf
    install -Dm644 $src/README.md $out/share/doc/qcp/README.md
    install -Dm644 $src/LICENSE $out/share/doc/qcp/LICENSE
  '';

  checkFlags = [
    # SSH home directory tests will not work in nix sandbox
    "--skip=config::ssh::includes::test::home_dir"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Experimental high-performance remote file copy utility for long-distance internet connections";
    homepage = "https://github.com/crazyscot/qcp";
    changelog = "https://github.com/crazyscot/qcp/releases/tag/v{version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ poptart ];
    mainProgram = "qcp";
  };
}
