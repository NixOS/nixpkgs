{ lib
, stdenv
, autoreconfHook
, bash
, boost
, bzip2
, cereal_1_3_2
, cmake
, curl
, fetchFromGitHub
, jemalloc
, libgff
, libiconv
, libstaden-read
, pkg-config
, tbb_2021_8
, xz
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "salmon";
  version = "1.10.2";

  pufferFishSrc = fetchFromGitHub {
    owner = "COMBINE-lab";
    repo = "pufferfish";
    rev = "salmon-v${finalAttrs.version}";
    hash = "sha256-JKbUFBEsqnENl4vFqve1FCd4TI3n9bRi2RNHC8QGQGc=";
  };

  src = fetchFromGitHub {
    owner = "COMBINE-lab";
    repo = "salmon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kwqoUmVCqjr/xRxJjQKaFjjCQW+MFASHJ2f9OiAumNU=";
  };

  patches = [
    # Use pufferfish source fetched by nix
    ./fetch-pufferfish.patch
  ];

  postPatch = "patchShebangs .";

  buildInputs = [
    (boost.override { enableShared = false; enabledStatic = true; })
    bzip2
    cereal_1_3_2
    curl
    jemalloc
    libgff
    libstaden-read
    tbb_2021_8
    xz
    zlib
  ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  nativeBuildInputs = [ cmake pkg-config ];

  strictDeps = true;

  meta = {
    description =
      "Tool for quantifying the expression of transcripts using RNA-seq data";
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
    changelog = "https://github.com/COMBINE-lab/salmon/releases/tag/" +
                "v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.kupac ];
  };
})
