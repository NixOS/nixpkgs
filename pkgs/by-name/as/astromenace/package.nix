{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ninja,
  makeWrapper,
  libxinerama,
  libx11,
  libice,
  libGLU,
  libGL,
  SDL2,
  openal,
  fontconfig,
  freealut,
  freetype,
  libogg,
  libvorbis,
  runtimeShell,
}:

stdenv.mkDerivation rec {
  pname = "astromenace";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "viewizard";
    repo = "astromenace";
    rev = "v${version}";
    hash = "sha256-W6d+8iw7/r2qJbE75U7egxqvK2HXaKzk+GtnspZRAxk=";
  };

  patches = [
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/astromenace/raw/5e6bc02d115a53007dc47ef8223d8eaa25607588/f/astromenace-gcc13.patch";
      hash = "sha256-pkmTVR86vS+KCICxAp+d7upNWVnSNxwdKmxnbtqIvgU=";
    })

    (fetchpatch {
      name = "cmake-4.patch";
      url = "https://github.com/viewizard/astromenace/commit/eb42ddb1e86a3e67787bfd5e33ff2afdd6307142.patch";
      hash = "sha256-TQVcnDrKBFvcyYhWeeEQSRjuirtJ7wYFQV+f3bHikdA=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
    makeWrapper
  ];

  buildInputs = [
    libice
    libx11
    libxinerama
    libGLU
    libGL
    SDL2
    openal
    fontconfig
    freealut
    freetype
    libogg
    libvorbis
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/astromenace
    install -Dm644 gamedata.vfs $out/share/astromenace/gamedata.vfs
    install -Dm755 astromenace $out/bin/astromenace
    wrapProgram $out/bin/astromenace \
      --add-flags "--dir=$out/share/astromenace"
    runHook postInstall
  '';

  meta = {
    description = "Hardcore 3D space shooter with spaceship upgrade possibilities";
    homepage = "https://www.viewizard.com/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "astromenace";
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
