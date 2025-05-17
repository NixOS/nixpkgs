{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  poppler-utils,
  tesseract,
  catdoc,
  unrtf,
  python3,
  python3Packages,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "rlama";
  version = "0.1.36";

  src = fetchFromGitHub {
    owner = "dontizi";
    repo = "rlama";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SzrnpAkh+SMzF9xOAxZXondRulwPRUZYHrhe3rf06bA=";
  };

  vendorHash = "sha256-GHmLCgL79BdGw/5zz50Y1kR/6JYNalvOj2zjIHQ9IF0=";

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  # Skip tests that require Ollama
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/rlama \
      --prefix PATH : ${
        lib.makeBinPath [
          poppler-utils
          tesseract
          catdoc
          unrtf
          python3
          python3Packages.pdfminer-six
          python3Packages.docx2txt
          python3Packages.xlsx2csv
          python3Packages.torch
          python3Packages.transformers
        ]
      }
  '';

  # Skip version check which tries to run the program (causing HOME issues)
  doInstallCheck = false;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Retrieval-Augmented Language Model Adapter";
    homepage = "https://github.com/dontizi/rlama";
    changelog = "https://github.com/dontizi/rlama/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "rlama";
  };
})
