{ stdenv, lib, fetchFromGitHub, pkgconfig, glib }:

with lib;
with builtins;

stdenv.mkDerivation rec {
  pname = "conmon";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner  = "containers";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "08fgkbv7hq62lcq39za9pm2s2j92ismgrkvfm7acwbvajqh9syjb";
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
