{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, which
, fltk
, mbedtls_2
}:

stdenv.mkDerivation {
  pname = "dillong";
  version = "unstable-2021-12-13";

  src = fetchFromGitHub {
    owner = "w00fpack";
    repo = "dilloNG";
    rev = "2804e6e9074b840de3084abb80473983f8e49f5b";
    hash = "sha256-JSBd8Lgw3I20Es/jQHBtybnLd0iAcs16TqOrOxGPGiU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    which
  ];

  buildInputs = [
    fltk
    mbedtls_2
  ];

  # The start_page and home settings refer to /usr.
  # We can't change /usr to $out because dillorc is copied to the home directory
  # on first launch, so the paths would quickly become outdated.
  # So we just comment them out, and let dillong use the defaults.
  postPatch = ''
    substituteInPlace dillorc \
      --replace "start_page=" "#start_page=" \
      --replace "home=" "#home="
  '';

  configureFlags = [ "--enable-ssl=yes" ];

  # Workaround build failure on -fno-common toolchains:
  #   ld: main.o:/build/dillo-3.0.5/dpid/dpid.h:64: multiple definition of `sock_set';
  #     dpid.o:/build/dillo-3.0.5/dpid/dpid.h:64: first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

  meta = with lib; {
    description = "Fork of Dillo, a lightweight web browser";
    homepage = "https://github.com/w00fpack/dilloNG";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fgaz ];
  };
}
