{ buildNpmPackage
, darwin
, fetchFromGitHub
, lib
, python3
, stdenv
}:

buildNpmPackage rec {
  pname = "nest-cli";
  version = "10.4.7";

  src = fetchFromGitHub {
    owner = "nestjs";
    repo = pname;
    rev = version;
    hash = "sha256-DVLmB4WE+8p2i2l2aq7u/YefeEykKd3B7ekaq5vKUjI=";
  };

  npmDepsHash = "sha256-bgnbf2YyjndJQ4jX08gW6htGPLV+znARuaJBuh8Kwa8=";

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
