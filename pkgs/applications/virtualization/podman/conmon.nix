{ stdenv, lib, fetchFromGitHub, pkgconfig, glib }:

with lib;

stdenv.mkDerivation rec {
  name = "conmon-${version}";
  version = "unstable-2018-11-28";
  rev = "8fba206232c249a8fc4e2fac1469fb2fddbf5cf7";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "conmon";
    sha256 = "07ar0dk9i072b14f6il51yqahxp5c4fkf5jzar8rxcpvymkdy8zq";
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
