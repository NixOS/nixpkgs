{ lib, stdenv
, fetchFromGitHub
, pkg-config
, fetchpatch
, fetchpatch2
, scons
, boost
, dvdauthor
, dvdplusrwtools
, enca
, cdrkit
, ffmpeg_6
, gettext
, gtk2
, gtkmm2
, libdvdread
, libxmlxx
, mjpegtools
, wrapGAppsHook3
}:

stdenv.mkDerivation {
  pname = "bombono";
  version = "1.2.4-unstable-2022-02-06";

  src = fetchFromGitHub {
    owner = "bombono-dvd";
    repo = "bombono-dvd";
    rev = "8680f5803314e4bcfbdae44f555c47ad345dae72";
    hash = "sha256-8AxXIvShH4HwlPZWAszku33rts13HiNoRsHiLYdZAHA=";
  };

  patches = [
    (fetchpatch {
      name = "bombono-dvd-1.2.4-scons3.patch";
      url = "https://svnweb.mageia.org/packages/cauldron/bombono-dvd/current/SOURCES/bombono-dvd-1.2.4-scons-python3.patch?revision=1447925&view=co&pathrev=1484457";
      sha256 = "sha256-5OKBWrRZvHem2MTdAObfdw76ig3Z4ZdDFtq4CJoJISA=";
    })

    # Fix compilation errors having ffmpeg 2:5.1
    # https://github.com/bombono-dvd/bombono-dvd/pull/28
    (fetchpatch2 {
      url = "https://github.com/bombono-dvd/bombono-dvd/commit/9f2cde1ddc22705bf58264739685086755b2138b.patch?full_index=1";
      hash = "sha256-ks6c04HEYF4nPfSOjzG+dUt9v7ZmNBb0XH6byPYqX5I=";
    })
  ];

  postPatch = ''
    substituteInPlace src/mbase/SConscript \
      --replace "lib_mbase_env['CPPDEFINES']" "list(lib_mbase_env['CPPDEFINES'])"
  '';

  nativeBuildInputs = [ wrapGAppsHook3 scons pkg-config gettext ];

  buildInputs = [
    boost
    dvdauthor
    dvdplusrwtools
    enca
    ffmpeg_6
    gtk2
    gtkmm2
    libdvdread
    libxmlxx
    mjpegtools
  ];

  prefixKey = "PREFIX=";

  enableParallelBuilding = true;

  postInstall = ''
    # fix iso authoring
    install -Dt  $out/share/bombono/resources/scons_authoring tools/scripts/SConsTwin.py

    wrapProgram $out/bin/bombono-dvd --prefix PATH : ${lib.makeBinPath [ ffmpeg_6 dvdauthor cdrkit ]}
  '';

  meta = with lib; {
    description = "DVD authoring program for personal computers";
    homepage = "https://www.bombono.org/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ symphorien ];
    platforms = platforms.linux;
  };
}
