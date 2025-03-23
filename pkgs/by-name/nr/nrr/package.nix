{
  lib,
  rustPlatform,
  fetchFromGitHub,
  enableLTO ? true,
  nrxAlias ? true,
}:
rustPlatform.buildRustPackage rec {
  pname = "nrr";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "ryanccn";
    repo = "nrr";
    rev = "v${version}";
    hash = "sha256-9QoYkYuN9kbcjgjn+7CuqKOKrVaPu8U2W/4KB+M04hg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ZAGR7Slpt3uUWO7g4GFr7tn8/fYeAxPYZivKAhLkar4=";

  env = lib.optionalAttrs enableLTO {
    CARGO_PROFILE_RELEASE_LTO = "fat";
    CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "1";
  };

  postInstall = lib.optionalString nrxAlias "ln -s $out/bin/nr{r,x}";

  meta = with lib; {
    description = "Minimal, blazing fast npm scripts runner";
    homepage = "https://github.com/ryanccn/nrr";
    maintainers = with maintainers; [ ryanccn ];
    license = licenses.gpl3Only;
    mainProgram = "nrr";
  };
}
