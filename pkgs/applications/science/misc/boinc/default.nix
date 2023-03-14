{ fetchFromGitHub
, lib
, stdenv
, autoconf
, automake
, pkg-config
, m4
, curl
, libGLU
, libGL
, libXmu
, libXi
, freeglut
, libjpeg
, libtool
, wxGTK32
, xcbutil
, sqlite
, gtk3
, patchelf
, libXScrnSaver
, libnotify
, libX11
, libxcb
}:

stdenv.mkDerivation rec {
  pname = "boinc";
  version = "7.22.0";

  src = fetchFromGitHub {
    name = "${pname}-${version}-src";
    owner = "BOINC";
    repo = "boinc";
    rev = "client_release/${lib.versions.majorMinor version}/${version}";
    hash = "sha256-AVWgFsxeuHADEat83XQLLeQkzw3kaUdPL0rp8b6Rxyk=";
  };

  nativeBuildInputs = [ libtool automake autoconf m4 pkg-config ];

  buildInputs = [
    curl
    libGLU
    libGL
    libXmu
    libXi
    freeglut
    libjpeg
    wxGTK32
    sqlite
    gtk3
    libXScrnSaver
    libnotify
    patchelf
    libX11
    libxcb
    xcbutil
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
    platforms = platforms.linux;
    maintainers = with maintainers; [ Luflosi ];
  };
}
