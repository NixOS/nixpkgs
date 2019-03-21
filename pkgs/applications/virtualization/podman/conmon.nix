{ stdenv, lib, fetchFromGitHub, pkgconfig, glib }:

with lib;

stdenv.mkDerivation rec {
  name = "conmon-${version}";
  version = "unstable-2019-02-15";
  rev = "cc2b49590a485da9bd358440f92f219dfd6b230f";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "conmon";
    sha256 = "13f5as4a9y6nkmr7cg0n27c2hfx9pkr75fxq2m0hlpcwhaardbm7";
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
