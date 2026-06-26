{
  lib,
  stdenv,
  boost,
  bzip2,
  catch2_3,
  cereal,
  cmake,
  curl,
  fetchFromGitHub,
  htslib,
  icu,
  jemalloc,
  libdeflate,
  libgff,
  libiconv,
  libstaden-read,
  mimalloc,
  onetbb,
  openssl,
  pkg-config,
  python3,
  xz,
  zlib-ng,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "salmon";
  version = "1.12.1";

  # SALMON_PUFFERFISH_GIT_TAG defined in cmake/SalmonDependencies.cmake
  pufferFishSrc = fetchFromGitHub {
    owner = "COMBINE-lab";
    repo = "pufferfish";
    fetchSubmodules = true;
    rev = "1c788594cef77f0558b183281f32152e0ed22ba9";
    hash = "sha256-N9KYmFsl90eY8R1wH1Jbi3nnNld6YVGeQjqoxYxPqtE=";
  };

  # SALMON_FQFEEDER_GIT_TAG defined in cmake/SalmonDependencies.cmake
  FQFeederSrc = fetchFromGitHub {
    owner = "rob-p";
    repo = "FQFeeder";
    rev = "f5b08d1002351c192b69048ac9f6cf4c7c116265";
    hash = "sha256-csRKUdNlEKKHNIvKRRTt79+27LBmnsJpswzBnWtA/XU=";
  };

  src = fetchFromGitHub {
    owner = "COMBINE-lab";
    repo = "salmon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ggFPp6sHPcR4Wq/B0AaMVf0LZVIz+QcvKMNrTfnAY4w=";
  };

  patches = [ ./fix_pufferfish.patch ];

  postPatch = ''
    patchShebangs .

    substituteInPlace CMakeLists.txt --replace-fail "CMP0167 OLD" "CMP0167 NEW"
  '';

  buildInputs = [
    (boost.override {
      enableShared = false;
      enabledStatic = true;
    })
    bzip2
    catch2_3
    cereal
    curl
    htslib
    icu
    jemalloc
    libdeflate
    libgff
    libstaden-read
    mimalloc
    onetbb
    openssl
    xz
    zlib-ng
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  cmakeFlags = [
    "-DSALMON_PUFFERFISH_SOURCE_DIR=${finalAttrs.pufferFishSrc}"
    "-DSALMON_FQFEEDER_SOURCE_DIR=${finalAttrs.FQFeederSrc}"
    "-DSALMON_FETCH_MISSING_DEPS=OFF"
  ];

  # These are needed to please htslib
  env.NIX_LDFLAGS = toString [
    "-lcrypto"
    "-ldeflate"
  ];

  strictDeps = true;

  meta = {
    description = "Tool for quantifying the expression of transcripts using RNA-seq data";
    mainProgram = "salmon";
    longDescription = ''
      Salmon is a tool for quantifying the expression of transcripts
      using RNA-seq data. Salmon uses new algorithms (specifically,
      coupling the concept of quasi-mapping with a two-phase inference
      procedure) to provide accurate expression estimates very quickly
      and while using little memory. Salmon performs its inference using
      an expressive and realistic model of RNA-seq data that takes into
      account experimental attributes and biases commonly observed in
      real RNA-seq data.
    '';
    homepage = "https://combine-lab.github.io/salmon";
    downloadPage = "https://github.com/COMBINE-lab/salmon/releases";
    changelog = "https://github.com/COMBINE-lab/salmon/releases/tag/" + "v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
