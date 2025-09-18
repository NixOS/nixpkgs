{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapGAppsHook3,
  cmake,
  pkg-config,
  fftwFloat,
  alsa-lib,
  zlib,
  wavpack,
  wxGTK32,
  udev,
  jackaudioSupport ? false,
  libjack2,
  imagemagick,
  libicns,
  yaml-cpp,
  makeWrapper,
  includeDemo ? true,
}:

stdenv.mkDerivation rec {
  pname = "grandorgue";
  version = "3.16.1-1";

  src = fetchFromGitHub {
    owner = "GrandOrgue";
    repo = "grandorgue";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-GaO05zFurxnOOUjUpeR5j0lP4EYR/EgxFpdgwfYHG9M=";
  };

  patches = [ ./darwin-fixes.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
    imagemagick
    libicns
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    fftwFloat
    zlib
    wavpack
    wxGTK32
    yaml-cpp
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    udev
  ]
  ++ lib.optional jackaudioSupport libjack2;

  cmakeFlags =
    lib.optionals (!jackaudioSupport) [
      "-DRTAUDIO_USE_JACK=OFF"
      "-DRTMIDI_USE_JACK=OFF"
      "-DGO_USE_JACK=OFF"
      "-DINSTALL_DEPEND=OFF"
    ]
    ++ lib.optional (!includeDemo) "-DINSTALL_DEMO=OFF";

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin,lib}
    mv $out/GrandOrgue.app $out/Applications/
    for lib in $out/Applications/GrandOrgue.app/Contents/Frameworks/lib*; do
      ln -s $lib $out/lib/
    done
    makeWrapper $out/{Applications/GrandOrgue.app/Contents/MacOS,bin}/GrandOrgue
  '';

  meta = {
    description = "Virtual Pipe Organ Software";
    homepage = "https://github.com/GrandOrgue/grandorgue";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.puzzlewolf ];
    mainProgram = "GrandOrgue";
  };
}
