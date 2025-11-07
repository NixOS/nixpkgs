{
  lib,
  stdenv,
  fetchurl,
  ffmpeg,
  glib,
  libGLU,
  libICE,
  libX11,
  libgbm,
  perl,
  pkg-config,
  proj,
  gdal,
  python3,
  wrapGAppsHook3,
  wxGTK32,
}:

stdenv.mkDerivation rec {
  pname = "survex";
  version = "1.4.17";

  src = fetchurl {
    url = "https://survex.com/software/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-r24vcOV1pjNxnLRfy2tSG7bDG/HLChwEvlc83YMeOEc=";
  };

  nativeBuildInputs = [
    perl
    pkg-config
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    ffmpeg
    glib
    proj
    gdal
    wxGTK32
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # TODO: libGLU doesn't build for macOS because of Mesa issues
    # (#233265); is it required for anything?
    libGLU
    libgbm
    libICE
    libX11
  ];

  strictDeps = true;

  postPatch = ''
    patchShebangs .
  '';

  configureFlags = [
    "WX_CONFIG=${lib.getExe' (lib.getDev wxGTK32) "wx-config"}"
  ];

  enableParallelBuilding = true;
  doCheck = (!stdenv.hostPlatform.isDarwin); # times out
  enableParallelChecking = false;

  meta = {
    description = "Free Software/Open Source software package for mapping caves";
    longDescription = ''
      Survex is a Free Software/Open Source software package for mapping caves,
      licensed under the GPL. It is designed to be portable and can be run on a
      variety of platforms, including Linux/Unix, macOS, and Microsoft Windows.
    '';
    homepage = "https://survex.com/";
    changelog = "https://github.com/ojwb/survex/raw/v${version}/NEWS";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.matthewcroughan ];
    platforms = lib.platforms.all;
  };
}
