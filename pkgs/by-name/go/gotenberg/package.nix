{
  lib,
  buildGoModule,
  chromium,
  fetchFromGitHub,
  libreoffice-unwrapped,
  makeBinaryWrapper,
  mktemp,
  makeFontsConf,
  liberation_ttf_v2,
  nixosTests,
  nix-update-script,
}:
let
  fontsConf = makeFontsConf { fontDirectories = [ liberation_ttf_v2 ]; };
  libreoffice' = "${libreoffice-unwrapped}/lib/libreoffice/program/soffice.bin";

  lok = buildGoModule (finalAttrs: {
    pname = "lok";
    version = "0.0.7";

    src = fetchFromGitHub {
      owner = "gotenberg";
      repo = "lok";
      tag = "v${finalAttrs.version}";
      hash = "sha256-PE68kH2CQoZDiL1+nIucsdlrfp/YDyRA34xbfbpELaA=";
    };

    patches = [ ./lok-script-xlb-writable.patch ];

    vendorHash = "sha256-t/vz/vbFS2B3L8igwbcSAddZ5pCHZvq/tiqUwLsvU3c=";

    buildInputs = [ libreoffice-unwrapped ];

    env.CGO_CFLAGS = "-DLOK_HAS_TRIM_MEMORY";

    meta = {
      description = "CLI and Go bindings for LibreOfficeKit";
      homepage = "https://github.com/gotenberg/lok";
      license = lib.licenses.mit;
      mainProgram = "lok";
    };
  });
in
buildGoModule (finalAttrs: {
  pname = "gotenberg";
  version = "9.9.2";

  outputs = [
    "out"
    "hyphen"
  ];

  src = fetchFromGitHub {
    owner = "gotenberg";
    repo = "gotenberg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OqLnbLymIzvuPeNwPOX+kI4EpuesaClvV0EKrKsDcMs=";
  };

  vendorHash = "sha256-AvAiSB61otqcMLGhebnLhFU7N+Gb98Tatz0H58htw5w=";

  postPatch = ''
    # github.com/gotenberg/litho explicitly requires Go 1.27.3
    substituteInPlace go.mod --replace-fail 'go 1.27.4' 'go 1.27.3'

    find ./pkg -name '*_test.go' -exec sed -i -e 's#/tests#${finalAttrs.src}#g' {} \;

    if ! grep -q '^ARG LOK_VERSION=v${lok.version}$' build/Dockerfile; then
      lok_version=$(sed -n 's/^ARG LOK_VERSION=v//p' build/Dockerfile)
      echo "Our lok version ${lok.version} does not match upstream's version $lok_version"
      exit 1
    fi
  '';

  nativeBuildInputs = [ makeBinaryWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gotenberg/gotenberg/v9/cmd.Version=${finalAttrs.version}"
  ];

  checkInputs = [
    chromium
    libreoffice-unwrapped
    lok
    mktemp
  ];

  preCheck = ''
    export CHROMIUM_BIN_PATH=${lib.getExe chromium}
    # LibreOffice needs all of these set to work properly
    export LIBREOFFICE_BIN_PATH=${libreoffice'}
    export LOK_BIN_PATH=${lib.getExe lok}
    export FONTCONFIG_FILE=${fontsConf}
    export HOME=$(mktemp -d)
  '';

  # These tests fail with a panic, so disable them.
  checkFlags =
    let
      skippedTests = [
        "TestChromiumBrowser_(screenshot|pdf)"
        "TestNewContext"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    mkdir $hyphen
    cp -r build/chromium-hyphen-data/*/* $hyphen/
  '';

  preFixup = ''
    wrapProgram $out/bin/gotenberg \
      --set CHROMIUM_HYPHEN_DATA_DIR_PATH "$hyphen" \
      --set LOK_BIN_PATH "${lib.getExe lok}"
  '';

  passthru = {
    inherit lok;
    tests = {
      inherit (nixosTests) gotenberg;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Converts numerous document formats into PDF files";
    mainProgram = "gotenberg";
    homepage = "https://gotenberg.dev";
    changelog = "https://github.com/gotenberg/gotenberg/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ miniharinn ];
  };
})
