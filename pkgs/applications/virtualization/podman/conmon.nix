{ stdenv, lib, fetchFromGitHub, pkgconfig, glib }:

with lib;

stdenv.mkDerivation rec {
  name = "conmon-${version}";
  version = "unstable-2019-03-19";
  rev = "84c860029893e2e2dd71d62231f009c9dcd3c0b4";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "conmon";
    sha256 = "1ydidl3s7s5rfwk9gx0k80nxcixlilxw61g7x0vqsdy3mkylysv5";
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
