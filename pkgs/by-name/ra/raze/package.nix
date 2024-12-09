{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  SDL2,
  zmusic,
  libvpx,
  pkg-config,
  makeWrapper,
  bzip2,
  gtk3,
  fluidsynth,
  openal,
  libGL,
  vulkan-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "raze";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "ZDoom";
    repo = "Raze";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-R3Sm/cibg+D2QPS4UisRp91xvz3Ine2BUR8jF5Rbj1g=";
    leaveDotGit = true;
    postFetch = ''
      cd $out
      git rev-parse HEAD > COMMIT
      rm -rf .git
    '';
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    SDL2
    zmusic
    libvpx
    bzip2
    gtk3
    fluidsynth
    openal
    libGL
    vulkan-loader
  ];

  cmakeFlags = [
    (lib.cmakeBool "DYN_GTK" false)
    (lib.cmakeBool "DYN_OPENAL" false)
  ];

  postPatch = ''
    substituteInPlace tools/updaterevision/gitinfo.h.in \
      --replace-fail "@Tag@" "${finalAttrs.version}" \
      --replace-fail "@Hash@" "$(cat COMMIT)" \
      --replace-fail "@Timestamp@" "1970-01-01 00:00:01 +0000"
  '';

  postInstall = ''
    mv $out/bin/raze $out/share/raze
    makeWrapper $out/share/raze/raze $out/bin/raze \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath [ vulkan-loader ]}
    install -Dm644 ../source/platform/posix/org.zdoom.Raze.256.png $out/share/pixmaps/org.zdoom.Raze.png
    install -Dm644 ../source/platform/posix/org.zdoom.Raze.desktop $out/share/applications/org.zdoom.Raze.desktop
    install -Dm644 ../soundfont/raze.sf2 $out/share/raze/soundfonts/raze.sf2
  '';

  meta = {
    description = "Build engine port backed by GZDoom tech";
    longDescription = ''
      Raze is a fork of Build engine games backed by GZDoom tech and combines
      Duke Nukem 3D, Blood, Redneck Rampage, Shadow Warrior and Exhumed/Powerslave
      in a single package. It is also capable of playing Nam and WW2 GI.
    '';
    homepage = "https://github.com/ZDoom/Raze";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ qubitnano ];
    mainProgram = "raze";
    platforms = [ "x86_64-linux" ];
  };
})
