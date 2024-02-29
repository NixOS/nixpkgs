{ lib
, buildNpmPackage
, fetchFromGitHub
, nodejs_20
}:

buildNpmPackage rec {
  pname = "homebridge";
  version = "1.7.0";
  src = fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge";
    rev = "v${version}";
    hash = "sha256-FYwIMQrJ/QNrwEfvI7MMKaiCYJS5E7s90yNVYwk6SS4=";
  };

  nodejs = nodejs_20;

  npmDepsHash = "sha256-g95wdWVnJf8UQDNuiFZ8/Dv6sMvNzGfdo7Ww+VqO71A=";

  meta = {
    description = "Homebridge";
    homepage = "https://github.com/homebridge/homebridge";
    license = lib.licenses.asl20;
    mainProgram = "homebridge";
    maintainers = with lib.maintainers; [ fmoda3 ];
  };
}
