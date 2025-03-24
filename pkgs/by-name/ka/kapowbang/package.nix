{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kapowbang";
  version = "0.7.1";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "BBVA";
    repo = "kapow";
    rev = "v${version}";
    sha256 = "sha256-HUZ1Uf8Z2YbYvqKEUHckKAZ5q+C83zafi3UjemqHFM4=";
  };

  vendorHash = "sha256-vvC9l/6b7AIEmCMVdeKMyi9ThIcAzjtV+uaQ4oSJZuU=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/BBVA/kapow";
    description = "Expose command-line tools over HTTP";
    license = licenses.asl20;
    maintainers = with maintainers; [ nilp0inter ];
    mainProgram = "kapow";
  };
}
