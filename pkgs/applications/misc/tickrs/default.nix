{ lib, stdenv, rustPlatform, fetchFromGitHub, perl }:

rustPlatform.buildRustPackage rec {
  pname = "tickrs";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "tarkah";
    repo = pname;
    rev = "v${version}";
    sha256 = "159smcjrf5193yijfpvy1g9b1gin72xwbjghfyrrphwscwhb215z";
  };

  cargoSha256 = "1s95b3x7vs1z8xs7j6j80y6mfpy5bdgnzmzn3qa9zr6cghabbf6n";

  nativeBuildInputs = [ perl ];

  meta = with lib; {
    description = "Realtime ticker data in your terminal";
    homepage = "https://github.com/tarkah/tickrs";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
