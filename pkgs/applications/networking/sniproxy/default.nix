{ lib, stdenv, fetchFromGitHub, autoreconfHook, gettext, libev, pcre, pkg-config, udns }:

stdenv.mkDerivation rec {
  pname = "sniproxy";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "dlundquist";
    repo = "sniproxy";
    rev = version;
    sha256 = "sha256-htM9CrzaGnn1dnsWQ+0V6N65Og7rsFob3BlSc4UGfFU=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ gettext libev pcre udns ];

  meta = with lib; {
    homepage = "https://github.com/dlundquist/sniproxy";
    description = "Transparent TLS and HTTP layer 4 proxy with SNI support";
    license = licenses.bsd2;
    maintainers = with maintainers; [ womfoo raitobezarius ];
    platforms = platforms.linux;
    mainProgram = "sniproxy";
  };

}
