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
  version = "0.3.3";

  # Tags required to fix the binary version
  GITHUB_REF_TYPE = "tag";
  GITHUB_REF_NAME = finalAttrs.version;

  src = fetchFromGitHub {
    owner = "crazyscot";
    repo = "qcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NlRM8FGYBmvT7KDOYTyUWTeERa96UPebuyicncJ4ANY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-PIu8bIu1Vr4GuUCqU9hmWFq5YU/uOwT0wDXjfirLijo=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage $src/qcp/misc/qcp.1 $src/qcp/misc/qcp_config.5
    install -Dm644 $src/qcp/misc/20-qcp.conf $out/etc/sysctl.d/20-qcp.conf
    install -Dm644 $src/qcp/misc/qcp.conf $out/etc/qcp.conf
  '';

  checkFlags = [
    # SSH home directory tests will not work in nix sandbox
    "--skip=config::ssh::includes::test::home_dir"
  ];

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
