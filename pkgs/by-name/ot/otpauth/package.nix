{
  lib,
  fetchFromGitHub,
  buildGo124Module,
}:

buildGo124Module rec {
  pname = "otpauth";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "dim13";
    repo = "otpauth";
    rev = "v${version}";
    sha256 = "sha256-QpQuMeldkZRXFi7I2yc7HS45gvsneZdPsSzkGWmnMX8=";
  };

  vendorHash = "sha256-Vx+nSSXidSJdEDoI2Bzx+5CQstNmW9dIOg8jEpAaguQ=";

  meta = with lib; {
    description = "Google Authenticator migration decoder";
    mainProgram = "otpauth";
    homepage = "https://github.com/dim13/otpauth";
    license = licenses.isc;
    maintainers = with maintainers; [ ereslibre ];
  };
}
