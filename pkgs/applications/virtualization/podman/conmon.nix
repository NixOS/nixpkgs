{ stdenv, lib, fetchFromGitHub, pkgconfig, glib }:

with lib;
with builtins;

stdenv.mkDerivation rec {
  name = "conmon-${version}";
  version = "0.0.1pre52_${substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner  = "containers";
    repo   = "conmon";
    rev    = "6905a4dc47830fbd1110e937228057c0b073ebe1";
    sha256 = "1igny1hr2q1zrhsaxcx7l8xkdr5ragl8pj18qbr1lpa2v5v2f6hs";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib ];

  installPhase = ''
    install -D -m 555 bin/conmon $out/bin/conmon
  '';

  meta = {
    homepage = https://github.com/containers/conmon;
    description = "An OCI container runtime monitor";
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester ];
    platforms = platforms.linux;
  };
}
