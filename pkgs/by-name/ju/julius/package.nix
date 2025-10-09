{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_mixer,
  cmake,
  libpng,
  darwin,
  libicns,
  imagemagick,
}:
stdenv.mkDerivation rec {
  pname = "julius";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "bvschaik";
    repo = "julius";
    rev = "v${version}";
    hash = "sha256-ppA/lCugFfzcbANuyWUvH3/1STNRdYOhRNR4tlfWEhc=";
  };

  patches = [
    # This fixes the build with cmake 4
    ./cmake4.patch
    # This fixes the darwin bundle generation, sets min. deployment version
    # and patches SDL2_mixer include
    ./darwin-fixes.patch
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

  meta = with lib; {
    homepage = "https://github.com/bvschaik/julius";
    description = "Open source re-implementation of Caesar III";
    mainProgram = "julius";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      Thra11
      matteopacini
    ];
    platforms = platforms.all;
  };
}
