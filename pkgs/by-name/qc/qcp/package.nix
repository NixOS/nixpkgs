{
  lib,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qcp";
  version = "0.4.1";

  # Tags required to fix the binary version
  GITHUB_REF_TYPE = "tag";
  GITHUB_REF_NAME = finalAttrs.version;

  src = fetchFromGitHub {
    owner = "crazyscot";
    repo = "qcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BCUhj60Y4QyE7EFcbfKgkEz8qULD1ONFtdqVo2DJot0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-IFIAvFvkvMW/BBC16fP67Hhg616QqcTsF1v+V8Lt1iI=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage $src/qcp/misc/qcp.1 $src/qcp/misc/qcp_config.5
    install -Dm644 $src/qcp/misc/20-qcp.conf $out/etc/sysctl.d/20-qcp.conf
    install -Dm644 $src/qcp/misc/qcp.conf $out/etc/qcp.conf
  '';

  checkFlags = [
    # SSH home directory tests will not work in nix sandbox
    "--skip=config::ssh::includes::test::home_dir"
    "--skip=control::process::test::ssh_no_such_host"
    # Attempts to reach outside of the nix sandbox
    "--skip=os::unix::test::config_paths"
    # Permission checks in the sandbox appear to always fail
    "--skip=session::get::test::permission_denied"
    # Multiple network tests will fail in sanbox
    "--skip=util::dns::tests::ipv4"
    "--skip=util::dns::tests::ipv6"
    # Tracing attempts to access stdout and angers the sandbox
    "--skip=util::tracing::test::test_create_layers_with_invalid_level"
  ];
  checkType = "debug";
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Experimental high-performance remote file copy utility for long-distance internet connections";
    homepage = "https://github.com/crazyscot/qcp";
    changelog = "https://github.com/crazyscot/qcp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ poptart ];
    mainProgram = "qcp";
  };
})
