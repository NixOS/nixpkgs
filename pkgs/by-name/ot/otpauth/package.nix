{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "otpauth";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "dim13";
    repo = "otpauth";
    rev = "v${version}";
    sha256 = "sha256-9N13rXnUFimOTBEw2yDhbp2rUDt850SkVvVoOphhxbc=";
  };

  vendorHash = "sha256-FZ5nWw9BYzQKWTDX1jRreaOaMkhWf/VeQx9vHdGYuKc=";

  meta = {
    description = "Google Authenticator migration decoder";
    mainProgram = "otpauth";
    homepage = "https://github.com/dim13/otpauth";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ ereslibre ];
  };
}
