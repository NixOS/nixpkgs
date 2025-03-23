{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  poppler-utils,
  tesseract,
  catdoc,
  python3Packages,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "rlama";
  version = "0.1.30";

  src = fetchFromGitHub {
    owner = "dontizi";
    repo = "rlama";
    tag = "v${version}";
    hash = "sha256-J4FTRWQfdmWXMhlwINQgqj7sCvF3+0YZwcZFW8y1CgY=";
  };

  vendorHash = "sha256-XZVMnkv+WqUqM6jbgrO3P5CSDACH3vLFJ4Y79EOnD08=";

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/rlama \
      --prefix PATH : ${
        lib.makeBinPath [
          poppler-utils
          tesseract
          catdoc
          python3Packages.pdfminer-six
          python3Packages.docx2txt
          python3Packages.xlsx2csv
        ]
      }
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Retrieval-Augmented Language Model Adapter";
    homepage = "https://github.com/dontizi/rlama";
    changelog = "https://github.com/dontizi/rlama/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "rlama";
  };
}
