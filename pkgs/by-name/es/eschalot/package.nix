{ lib, stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "eschalot";
  version = "1.2.0.20191006";

  src = fetchFromGitHub {
    owner = "ReclaimYourPrivacy";
    repo = pname;
    rev = "a45bad5b9a3e4939340ddd8a751ceffa3c0db76a";
    sha256 = "1wbi0azc2b57nmmx6c1wmvng70d9ph1s83yhnl5lxaaqaj85h22g";
  };

  buildInputs = [ openssl ];

  installPhase = ''
    install -D -t $out/bin eschalot worgen
  '';

  meta = with lib; {
    description = "Tor hidden service name generator";
    homepage = src.meta.homepage;
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
}
