{
  lib,
  stdenv,
  fetchFromGitHub,
  libpulseaudio,
  pkg-config,
  gtk3,
  glibc,
  autoconf,
  automake,
  libnotify,
  libX11,
  xf86inputevdev,
}:

stdenv.mkDerivation {
  pname = "pa-applet";
  version = "0-unstable-2012-04-11";

  src = fetchFromGitHub {
    owner = "fernandotcl";
    repo = "pa-applet";
    rev = "005f192df9ba6d2e6491f9aac650be42906b135a";
    sha256 = "sha256-ihvZFXHgr5YeqMKmVY/GB86segUkQ9BYqJYfE3PTgog=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
  ];
  buildInputs = [
    gtk3
    libpulseaudio
    glibc
    libnotify
    libX11
    xf86inputevdev
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  # work around a problem related to gtk3 updates
  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  postInstall = "";

  meta = with lib; {
    description = "";
    mainProgram = "pa-applet";
    license = licenses.bsd2;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
