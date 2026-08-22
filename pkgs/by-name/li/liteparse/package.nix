{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
  cmake,
  makeWrapper,
  nix-update-script,
  openssl,
  pkg-config,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  leptonica,
  tesseract,
}:

let
  # Keep in sync with PDFIUM_RELEASE_TAG in upstream:
  # https://github.com/run-llama/liteparse/blob/main/crates/pdfium-sys/build.rs#L6
  pdfium =
    let
      asset =
        {
          "x86_64-linux" = "pdfium-linux-x64";
          "aarch64-linux" = "pdfium-linux-arm64";
        }
        .${stdenv.hostPlatform.system};

      hash =
        {
          "pdfium-linux-x64" = "sha256-r5byH9jp1TlVAT2tHRewA9ASACXnh7fOYRpoXVcodZQ=";
          "pdfium-linux-arm64" = "sha256-6B7ER90ACX6y/CbP+IvlPqMhSVcRpDr56ntQvr3qkiY=";
        }
        .${asset};
    in
    stdenv.mkDerivation {
      pname = "pdfium";
      version = "chromium-7897";

      __structuredAttrs = true;
      strictDeps = true;

      src = fetchurl {
        url = "https://github.com/run-llama/pdfium-binaries/releases/download/chromium%2F7897/${asset}.tgz";
        inherit hash;
      };

      unpackPhase = ''
        mkdir source
        tar -xzf $src -C source
      '';
      sourceRoot = "source";

      installPhase = ''
        cp -r . $out
      '';
    };

  # Reuse the same upstream sources as the nixpkgs leptonica/tesseract packages
  # so versions stay in sync without separate pins in this expression.
  leptonicaSrc = leptonica.src;
  tesseractSrc = tesseract.tesseractBase.src;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "liteparse";
  version = "2.13.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "run-llama";
    repo = "liteparse";
    tag = "crates-v${finalAttrs.version}";
    hash = "sha256-owKu03Gxou53hQbU9O+UniJTCxtGKshgO11sF6DNudI=";
  };

  postPatch = ''
    mkdir -p .tesseract-rs/third_party
    ln -s ${leptonicaSrc} .tesseract-rs/third_party/leptonica
    ln -s ${tesseractSrc} .tesseract-rs/third_party/tesseract
  ''
  # tesseract-rs builds leptonica/tesseract via cmake and expects libraries under
  # lib/, while newer upstream sources may install to lib64 on some platforms.
  + ''
    tesseractRsBuildRs=$(echo "$cargoDepsCopy"/source-registry-*/tesseract-rs-*/build.rs)
    substituteInPlace "$tesseractRsBuildRs" \
      --replace-fail \
        '.define("CMAKE_INSTALL_PREFIX", &leptonica_install_dir)' \
        '.define("CMAKE_INSTALL_PREFIX", &leptonica_install_dir)
                    .define("CMAKE_INSTALL_LIBDIR", "lib")' \
      --replace-fail \
        '.define("CMAKE_INSTALL_PREFIX", &tesseract_install_dir)' \
        '.define("CMAKE_INSTALL_PREFIX", &tesseract_install_dir)
                    .define("CMAKE_INSTALL_LIBDIR", "lib")'
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    openssl
    tesseract
  ];

  cargoHash = "sha256-rb/3L/SJqe1qKOIe33IfhORcFRtaJmB8TN70sdxhXkc=";
  cargoBuildFlags = [
    "--package"
    "liteparse"
  ];
  cargoInstallFlags = [
    "--path"
    "crates/liteparse"
  ];
  doCheck = false;

  preBuild = ''
    mkdir -p "$HOME/.tesseract-rs"
    cp -rL .tesseract-rs/third_party "$HOME/.tesseract-rs/"
    chmod -R u+w "$HOME/.tesseract-rs"
    mkdir -p "$HOME/.tesseract-rs/tessdata"
    cp ${tesseract.languages.eng} "$HOME/.tesseract-rs/tessdata/eng.traineddata"
    cp ${tesseract.languages.tur} "$HOME/.tesseract-rs/tessdata/tur.traineddata"
  '';

  env = {
    OPENSSL_NO_VENDOR = true;
    PDFIUM_INCLUDE_PATH = "${lib.getInclude pdfium}/include";
    PDFIUM_LIB_PATH = "${lib.getLib pdfium}/lib";
  };

  postInstall = ''
    wrapProgram $out/bin/lit \
      --set PDFIUM_LIB_PATH "${lib.getLib pdfium}/lib" \
      --set TESSDATA_PREFIX "${tesseract}/share/tessdata"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast and lightweight document parser by LlamaIndex";
    homepage = "https://github.com/run-llama/liteparse";
    changelog = "https://github.com/run-llama/liteparse/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "lit";
  };
})
