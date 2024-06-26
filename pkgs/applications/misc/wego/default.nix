{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wego";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "schachmat";
    repo = pname;
    rev = version;
    sha256 = "sha256-bkbH3RewlYYNamAhAZGWQmzNdGB06K3m/D8ScsQP9ic=";
  };

  vendorHash = "sha256-aXrXw/7ZtSZXIKDMZuWPV2zAf0e0lU0QCBhua7tHGEY=";

  meta = with lib; {
    homepage = "https://github.com/schachmat/wego";
    description = "Weather app for the terminal";
    license = licenses.isc;
    mainProgram = "wego";
  };
}
