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

let
  majorVersion = "7.20";
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
    sha256 = "sha256-vMb5Vq/6I6lniG396wd7+FfslsByedMRPIpiItp1d1s=";
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
