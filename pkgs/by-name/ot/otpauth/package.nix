{
  lib,
  fetchFromGitHub,
  buildGo124Module,
}:

buildGo124Module rec {
  pname = "otpauth";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "dim13";
    repo = "otpauth";
    rev = "v${version}";
    sha256 = "sha256-gxFhuFOSiyE7FLWqTZzKPZzXerwK2PWy7Z0zshAJ4Yg=";
  };

  vendorHash = "sha256-UXn+v8SAkEJ2tU3MudH2pDnLHBF4mzshHaovlzqm/fM=";

  meta = with lib; {
    description = "Google Authenticator migration decoder";
    mainProgram = "otpauth";
    homepage = "https://github.com/dim13/otpauth";
    license = licenses.isc;
    maintainers = with maintainers; [ ereslibre ];
  };
}
