{ buildNpmPackage
, darwin
, fetchFromGitHub
, lib
, python3
, stdenv
}:

buildNpmPackage rec {
  pname = "nest-cli";
  version = "10.4.9";

  src = fetchFromGitHub {
    owner = "nestjs";
    repo = pname;
    rev = version;
    hash = "sha256-dko+hOC3oZToNS+EOqmm+z7DLHfqqKDeQsH2sYxburU=";
  };

  npmDepsHash = "sha256-K4M6Jehy1854SuxDiaHQLlvhOecwInZZbOcgMqchiIM=";

  env = {
    npm_config_build_from_source = true;
  };

  nativeBuildInputs = [
    python3
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = with lib; {
    description = "CLI tool for Nest applications";
    homepage = "https://nestjs.com";
    license = licenses.mit;
    mainProgram = "nest";
    maintainers = [ maintainers.ehllie ];
  };
}
