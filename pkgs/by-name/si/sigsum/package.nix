{
  lib,
  buildGoModule,
  fetchFromGitLab,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "sigsum";
  version = "0.11.2";

  src = fetchFromGitLab {
    domain = "git.glasklar.is";
    group = "sigsum";
    owner = "core";
    repo = "sigsum-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oaYquy0N8yHfKLoNEv8Vte3dpp/UQFZ74mZHin8dDzw=";
  };

  postPatch = ''
    substituteInPlace internal/version/version.go \
      --replace-fail "info.Main.Version" '"${finalAttrs.version}"'
  '';

  vendorHash = "sha256-8Tyhd13PRTO2dGOdhkgYmwsVzWfqwOpZ9XSsAtiCcyM=";

  ldflags = [
    "-s"
    "-w"
  ];

  excludedPackages = [ "./test" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/sigsum-key";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "System for public and transparent logging of signed checksums";
    homepage = "https://www.sigsum.org/";
    downloadPage = "https://git.glasklar.is/sigsum/core/sigsum-go";
    changelog = "https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/v${finalAttrs.version}/NEWS";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ defelo ];
  };
})
