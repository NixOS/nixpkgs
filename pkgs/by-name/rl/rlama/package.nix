{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  makeBinaryWrapper,
  poppler-utils,
  tesseract,
  catdoc,
  unrtf,
  python3Packages,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "rlama";
  version = "0.1.39";

  src = fetchFromGitHub {
    owner = "dontizi";
    repo = "rlama";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9qm9QSMko+ZHfKMMaTesA26X4OuemyB/w1w+0QOEpyE=";
  };

  vendorHash = "sha256-GHmLCgL79BdGw/5zz50Y1kR/6JYNalvOj2zjIHQ9IF0=";

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  # Run only unit tests for core packages; skip e2e tests that require Ollama
  checkPhase = ''
    runHook preCheck

    go test -v ./internal/domain/... ./pkg/vector/... ./internal/repository/...

    runHook postCheck
  '';

  postInstall = ''
    wrapProgram $out/bin/rlama \
      --prefix PATH : ${
        lib.makeBinPath [
          poppler-utils
          tesseract
          catdoc
          unrtf
          python3Packages.pdfminer-six
          python3Packages.docx2txt
          python3Packages.xlsx2csv
          python3Packages.torch
          python3Packages.transformers
        ]
      }
  '';

  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    VERSION=$($out/bin/rlama --version | grep -o "${finalAttrs.version}" || true)
    if [ -z "$VERSION" ]; then
        echo "Version check failed: expected ${finalAttrs.version}, got: $($out/bin/rlama --version)"
      else
        echo "$VERSION"
    fi

    runHook postInstallCheck
  '';

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
