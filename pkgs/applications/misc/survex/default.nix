{ lib
, stdenv
, fetchurl
, Carbon
, Cocoa
, ffmpeg
, glib
, libGLU
, mesa
, perl
, pkg-config
, proj
, python3
, wrapGAppsHook
, wxGTK30-gtk3
, wxmac
, xlibsWrapper
}:

stdenv.mkDerivation rec {
  pname = "survex";
  version = "1.4.1";

  nativeBuildInputs = [
    perl
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    ffmpeg
    glib
    libGLU
    mesa
    proj
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Carbon
    Cocoa
    wxmac
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    wxGTK30-gtk3
    xlibsWrapper
  ];

  src = fetchurl {
    url = "https://survex.com/software/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-69X1jGjBTQIQzkD1mTZTzE8L/GXnnf5SI52l7eIiLz4=";
  };

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;
  doCheck = (!stdenv.isDarwin); # times out
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
