{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, libtool
, openssl
, expat
, pkg-config
, check
, zlib
}:

stdenv.mkDerivation rec {
  pname = "libstrophe";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "strophe";
    repo = pname;
    rev = version;
    hash = "sha256-JMuvWspgXs+1dVWoo6kJVaf6cVvYj8lhyyu4ZILKeOg=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ openssl expat libtool check zlib ];

  dontDisableStatic = true;

  strictDeps = true;

  doCheck = true;

  meta = with lib; {
    description = "Simple, lightweight C library for writing XMPP clients";
    longDescription = ''
      libstrophe is a lightweight XMPP client library written in C. It has
      minimal dependencies and is configurable for various environments. It
      runs well on both Linux, Unix, and Windows based platforms.
    '';
    homepage = "https://strophe.im/libstrophe/";
    license = with licenses; [ gpl3Only mit ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ devhell flosse ];
  };
}

