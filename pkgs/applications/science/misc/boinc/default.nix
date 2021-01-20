{ fetchFromGitHub, lib, stdenv, autoconf, automake, pkg-config, m4, curl,
libGLU, libGL, libXmu, libXi, freeglut, libjpeg, libtool, wxGTK30, xcbutil,
sqlite, gtk2, patchelf, libXScrnSaver, libnotify, libX11, libxcb }:

let
  majorVersion = "7.14";
  minorVersion = "2";
in

stdenv.mkDerivation rec {
  version = "${majorVersion}.${minorVersion}";
  pname = "boinc";

  src = fetchFromGitHub {
    name = "${pname}-${version}-src";
    owner = "BOINC";
    repo = "boinc";
    rev = "client_release/${majorVersion}/${version}";
    sha256 = "0nicpkag18xq0libfqqvs0im22mijpsxzfk272iwdd9l0lmgfvyd";
  };

  nativeBuildInputs = [ libtool automake autoconf m4 pkg-config ];

  buildInputs = [
    curl libGLU libGL libXmu libXi freeglut libjpeg wxGTK30 sqlite gtk2 libXScrnSaver
    libnotify patchelf libX11 libxcb xcbutil
  ];

  NIX_LDFLAGS = "-lX11";

  preConfigure = ''
    ./_autosetup
    configureFlags="$configureFlags --sysconfdir=$out/etc"
  '';

  enableParallelBuilding = true;

  configureFlags = [ "--disable-server" ];

  meta = {
    description = "Free software for distributed and grid computing";
    homepage = "https://boinc.berkeley.edu/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;  # arbitrary choice
  };
}
