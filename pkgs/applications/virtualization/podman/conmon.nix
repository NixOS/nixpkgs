{ stdenv, lib, fetchFromGitHub, pkgconfig, glib }:

with lib;

stdenv.mkDerivation rec {
  name = "conmon-${version}";
  version = "unstable-2019-04-17";
  rev = "c150bb3474d7575323e245d26c7edad58555de79";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "conmon";
    sha256 = "1cjxlbkbf1pz2jyn1gflga69c025p1qgb5lfq9pibrxls0zdqza6";
    inherit rev;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    glib
  ];

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
