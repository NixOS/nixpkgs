{ fetchFromGitHub, lib, stdenv, autoconf, automake, pkg-config, m4, curl,
libGLU, libGL, libXmu, libXi, freeglut, libjpeg, libtool, wxGTK30, xcbutil,
sqlite, gtk2, patchelf, libXScrnSaver, libnotify, libX11, libxcb }:

let
  majorVersion = "7.18";
  minorVersion = "1";
in

stdenv.mkDerivation rec {
  version = "${majorVersion}.${minorVersion}";
  pname = "boinc";

  src = fetchFromGitHub {
    name = "${pname}-${version}-src";
    owner = "BOINC";
    repo = "boinc";
    rev = "client_release/${majorVersion}/${version}";
    sha256 = "sha256-ijkfWTFwwJXvh6f0P5hkzWODxU+Ugz6iQUK+5jEpWXQ=";
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

  postInstall = ''
    install --mode=444 -D 'client/scripts/boinc-client.service' "$out/etc/systemd/system/boinc.service"
  '';

  meta = with lib; {
    description = "Free software for distributed and grid computing";
    homepage = "https://boinc.berkeley.edu/";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;  # arbitrary choice
    # checking for gcc options needed to detect all undeclared functions... cannot detect
    # configure: error: in `/build/boinc-7.18.1-src':
    # configure: error: cannot make gcc report undeclared builtins
    broken = stdenv.isAarch64;
    maintainers = with maintainers; [ Luflosi ];
  };
}
