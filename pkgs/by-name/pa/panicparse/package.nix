{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "panicparse";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "maruel";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KjWUubrHPJUJWvoa13EGEwTd5uNC0nrHAF8hzdnxEmY=";
  };

  vendorHash = "sha256-udkh/6Bu+7djxugMIuVsZvZ3JN2JooihsmcS2wJT0Wo=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Crash your app in style (Golang)";
    homepage = "https://github.com/maruel/panicparse";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "panicparse";
  };
}
