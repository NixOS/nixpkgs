{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  SDL2_mixer,
  libpng,
  darwin,
  libicns,
  imagemagick,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "augustus";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "Keriew";
    repo = "augustus";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-UWJmxirRJJqvL4ZSjBvFepeKVvL77+WMp4YdZuFNEkg=";
  };

  patches = [ ./darwin-fixes.patch ];

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
    cp -r augustus.app $out/Applications/
    runHook postInstall
  '';

  meta = {
    description = "Open source re-implementation of Caesar III. Fork of Julius incorporating gameplay changes";
    mainProgram = "augustus";
    homepage = "https://github.com/Keriew/augustus";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      Thra11
      matteopacini
    ];
  };
})
