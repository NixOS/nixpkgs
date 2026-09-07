{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gettext,
  libev,
  pcre2,
  pkg-config,
  udns,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sniproxy";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "dlundquist";
    repo = "sniproxy";
    tag = finalAttrs.version;
    hash = "sha256-TUXwixnBFdegYRzeXlLVno2M3gVXyCw5Jdfb9ulOROs=";
  };

  patches = [ ./gettext-0.25.patch ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    gettext
    libev
    pcre2
    udns
  ];

  meta = {
    homepage = "https://github.com/dlundquist/sniproxy";
    description = "Transparent TLS and HTTP layer 4 proxy with SNI support";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      womfoo
      raitobezarius
    ];
    platforms = lib.platforms.linux;
    mainProgram = "sniproxy";
  };
})
