{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "lndhub-go";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "lndhub.go";
    rev = version;
    sha256 = "sha256-m+Sc/rsYIbvd1oOqG4OT+wPtSxlgFq8m03n28eZIWJU=";
  };

  vendorHash = "sha256-a4yVuEfhLNM8IEYnafWf///SNLqQL5XZfGgJ5AZLx3c=";

  doCheck = false; # tests require networking

  meta = with lib; {
    description = "Accounting wrapper for the Lightning Network";
    homepage = "https://github.com/getAlby/lndhub.go";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prusnak ];
    mainProgram = "lndhub.go";
  };
}
