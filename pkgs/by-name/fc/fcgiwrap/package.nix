{
  lib,
  stdenv,
  fetchFromGitHub,
  systemd,
  fcgi,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fcgiwrap";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "gnosek";
    repo = "fcgiwrap";
    rev = finalAttrs.version;
    hash = "sha256-znAsZk+aB2XO2NK8Mjc+DLwykYKHolnVQPErlaAx3Oc=";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-fallthrough";
  configureFlags = [
    "--with-systemd"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    systemd
    fcgi
  ];

  # systemd 230 no longer has libsystemd-daemon as a separate entity from libsystemd
  postPatch = ''
    substituteInPlace configure.ac --replace libsystemd-daemon libsystemd
  '';

  meta = {
    homepage = "https://github.com/gnosek/fcgiwrap";
    description = "Simple server for running CGI applications over FastCGI";
    maintainers = [ ];
    platforms = with lib.platforms; linux;
    license = lib.licenses.mit;
    mainProgram = "fcgiwrap";
  };
})
