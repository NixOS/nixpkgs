{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "qwe";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "mainak55512";
    repo = "qwe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DbHyhsMoFm2nmR1LEqObz9eVJbAmW6+nx2QSXSBr2ik=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight, flexible, file-first version/revision control system";
    longDescription = ''
      Qwe (pronounced kiwi) makes version control effortless.  Track
      individual files with precision, group them seamlessly, and
      commit or revert changes individually or together — all in one
      lightweight, intuitive tool built for speed and simplicity.
    '';
    homepage = "https://github.com/mainak55512/qwe";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "qwe";
  };
})
