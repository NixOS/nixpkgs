{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    ./darwin-fixes.patch
    # CMake 4.5 rejects the extra arguments to install(CODE)
    (fetchpatch {
      url = "https://github.com/Keriew/augustus/commit/55f3c2cdf53f75818e9dfdf38efb544e6584c59a.patch";
      hash = "sha256-VboJnLIc/sgsPJNHbwu1zVB1fbqW2JFZ/VtIyjXHZno=";
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
    ];
  };
})
