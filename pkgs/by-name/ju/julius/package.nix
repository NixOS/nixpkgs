{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  SDL2,
  SDL2_mixer,
  cmake,
  libpng,
  darwin,
  libicns,
  imagemagick,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "julius";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "bvschaik";
    repo = "julius";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ppA/lCugFfzcbANuyWUvH3/1STNRdYOhRNR4tlfWEhc=";
  };

  patches = [
    # This fixes the build with cmake 4
    ./cmake4.patch
    # This fixes the darwin bundle generation, sets min. deployment version
    # and patches SDL2_mixer include
    ./darwin-fixes.patch
    # CMake 4.5 rejects the extra arguments to install(CODE)
    (fetchpatch {
      url = "https://github.com/bvschaik/julius/commit/9867661f37dda264b24abcc6309e3cab736c63de.patch";
      hash = "sha256-fyr4ePPDMQFtSnrDD1FDUYnKwoz85GcQfMx5YytlbmU=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.sigtool
    libicns
    imagemagick
  ];

  buildInputs = [
    SDL2
    SDL2_mixer
    libpng
  ];

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r julius.app $out/Applications/
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/bvschaik/julius";
    description = "Open source re-implementation of Caesar III";
    mainProgram = "julius";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      Thra11
    ];
    platforms = lib.platforms.all;
  };
})
