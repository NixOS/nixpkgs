{
  lib,
  buildGo127Module,
  fetchFromGitLab,
  versionCheckHook,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "sigsum";
  version = "1.0.0";

  src = fetchFromGitLab {
    domain = "git.glasklar.is";
    group = "sigsum";
    owner = "core";
    repo = "sigsum-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fmjYDhFchKCYND8h3rNlAg9CyN/rqzWcDXWPW6+Gak4=";
  };

  postPatch = ''
    substituteInPlace internal/version/version.go \
      --replace-fail "info.Main.Version" '"${finalAttrs.version}"'
  '';

  vendorHash = "sha256-f3vuVsGyHMjcUUAqoor6ue0axs4FkiMZcuPiwX3DpFI=";

  ldflags = [
    "-s"
    "-w"
  ];

  excludedPackages = [ "./test" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/sigsum-key";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^v(\\d+\\.\\d+\\.\\d+)$" ];
  };

  meta = {
    description = "System for public and transparent logging of signed checksums";
    homepage = "https://www.sigsum.org/";
    downloadPage = "https://git.glasklar.is/sigsum/core/sigsum-go";
    changelog = "https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/v${finalAttrs.version}/NEWS";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ defelo ];
  };
})
