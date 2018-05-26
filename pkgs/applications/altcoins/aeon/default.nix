{ stdenv, fetchFromGitHub, cmake, boost, miniupnpc, openssl, pkgconfig, unbound }:

let
  version = "0.9.14.0";
in
stdenv.mkDerivation {
  name = "aeon-${version}";

  src = fetchFromGitHub {
    owner = "aeonix";
    repo = "aeon";
    rev = "v${version}";
    sha256 = "0pl9nfhihj0wsdgvvpv5f14k4m2ikk8s3xw6nd8ymbnpxfzyxynr";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ boost miniupnpc openssl unbound ];

  installPhase = ''
    install -D src/aeond "$out/bin/aeond"
    install src/simpleminer "$out/bin/aeon-simpleminer"
    install src/simplewallet "$out/bin/aeon-simplewallet"
    install src/connectivity_tool "$out/bin/aeon-connectivity-tool"
  '';

  meta = with stdenv.lib; {
    description = "Private, secure, untraceable currency";
    homepage = http://www.aeon.cash/;
    license = licenses.bsd3;
    maintainers = [ maintainers.aij ];
    platforms = [ "x86_64-linux" ];
  };
}
