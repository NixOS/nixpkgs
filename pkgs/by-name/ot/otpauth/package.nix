{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "otpauth";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "dim13";
    repo = "otpauth";
    rev = "v${version}";
    hash = "sha256-h1aIb+PbKPPJsKM7OGVPO8epEfFdiX7IlqGIrPieS7Q=";
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
