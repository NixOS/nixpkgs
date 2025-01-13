{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "otpauth";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "dim13";
    repo = "otpauth";
    rev = "v${version}";
    sha256 = "sha256-q6QQST3SDskEXd6X55A4VgOM8tZITUrpHfI/NV+NSwk=";
  };

  vendorHash = "sha256-lATdsuqSM2EaclhvNN9BmJ6NC2nghDfggRrwvRjF7us=";

  meta = with lib; {
    description = "Google Authenticator migration decoder";
    mainProgram = "otpauth";
    homepage = "https://github.com/dim13/otpauth";
    license = licenses.isc;
    maintainers = with maintainers; [ ereslibre ];
  };
}
