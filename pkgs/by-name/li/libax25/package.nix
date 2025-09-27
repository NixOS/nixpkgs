{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  glibc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libax25";
  version = "0.0.12-rc5";

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    glibc
  ]
  ++ lib.optionals stdenv.hostPlatform.isStatic [ glibc.static ];

  # src from linux-ax25.in-berlin.de remote has been
  # unreliable, pointing to github mirror from the radiocatalog
  src = fetchFromGitHub {
    owner = "radiocatalog";
    repo = "libax25";
    tag = "libax25-${finalAttrs.version}";
    hash = "sha256-MQDrroRZhtWJiu3N7FQVp5/sqe1MDjdwKu4ufnfHTUM=";
  };

  configureFlags = [ "--sysconfdir=/etc" ];

  LDFLAGS = lib.optionals stdenv.hostPlatform.isStatic [
    "-static-libgcc"
    "-static"
  ];

  meta = with lib; {
    description = "AX.25 library for hamradio applications";
    homepage = "https://linux-ax25.in-berlin.de/wiki/Main_Page";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ sarcasticadmin ];
    platforms = platforms.linux;
  };
})
