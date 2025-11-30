{
  fetchFromGitHub,
  lib,
  stdenv,
  autoconf,
  automake,
  pkg-config,
  m4,
  curl,
  libGLU,
  libGL,
  libXmu,
  libXi,
  libglut,
  libjpeg,
  libtool,
  wxGTK32,
  xcbutil,
  sqlite,
  gtk3,
  patchelf,
  libXScrnSaver,
  libnotify,
  libX11,
  libxcb,
  headless ? false,
}:

stdenv.mkDerivation rec {
  pname = "boinc";
  version = "8.2.8";

  src = fetchFromGitHub {
    name = "${pname}-${version}-src";
    owner = "BOINC";
    repo = "boinc";
    rev = "client_release/${lib.versions.majorMinor version}/${version}";
    hash = "sha256-yCsqkC6kle2oE29KP5qILe0F+5AOpFl2S3s2c09x7N4=";
  };

  nativeBuildInputs = [
    libtool
    automake
    autoconf
    m4
    pkg-config
  ];

  buildInputs = [
    curl
    sqlite
    patchelf
  ]
  ++ lib.optionals (!headless) [
    libGLU
    libGL
    libXmu
    libXi
    libglut
    libjpeg
    wxGTK32
    gtk3
    libXScrnSaver
    libnotify
    libX11
    libxcb
    xcbutil
  ];

  NIX_LDFLAGS = lib.optionalString (!headless) "-lX11";

  preConfigure = ''
    ./_autosetup
  '';

  enableParallelBuilding = true;

  configureFlags = [
    "--disable-server"
    "--sysconfdir=${placeholder "out"}/etc"
  ]
  ++ lib.optionals headless [ "--disable-manager" ];

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
