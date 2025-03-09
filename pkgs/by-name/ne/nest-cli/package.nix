{ buildNpmPackage
, darwin
, fetchFromGitHub
, lib
, python3
, stdenv
}:

buildNpmPackage rec {
  pname = "nest-cli";
  version = "10.4.8";

  src = fetchFromGitHub {
    owner = "nestjs";
    repo = pname;
    rev = version;
    hash = "sha256-1IS9ZzAaKe+R4PmQWsLR9inz7ZM9N3VK7QSm0olNIag=";
  };

  npmDepsHash = "sha256-2nl/Lyd+K5MN0dtYNBFJOMwSDdt2eFxB7cTfc9543/U=";

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
