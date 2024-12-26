{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  Carbon,
  Cocoa,
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
  version = "1.4.14";

  src = fetchurl {
    url = "https://survex.com/software/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-TKOgbwUGE1z1PUZxfukugZWsJY1ml/VMAJ7xDIqWZWs=";
  };

  nativeBuildInputs = [
    perl
    pkg-config
    python3
    wrapGAppsHook3
  ];

  buildInputs =
    [
      ffmpeg
      glib
      proj
      gdal
      wxGTK32
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Carbon
      Cocoa
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      # TODO: libGLU doesn't build for macOS because of Mesa issues
      # (#233265); is it required for anything?
      libGLU
      libgbm
      libICE
      libX11
    ];

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;
  doCheck = (!stdenv.hostPlatform.isDarwin); # times out
  enableParallelChecking = false;

  meta = with lib; {
    description = "Free Software/Open Source software package for mapping caves";
    longDescription = ''
      Survex is a Free Software/Open Source software package for mapping caves,
      licensed under the GPL. It is designed to be portable and can be run on a
      variety of platforms, including Linux/Unix, macOS, and Microsoft Windows.
    '';
    homepage = "https://survex.com/";
    changelog = "https://github.com/ojwb/survex/raw/v${version}/NEWS";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.matthewcroughan ];
    platforms = platforms.all;
  };
}
