{
  lib,
  rustPlatform,
  fetchFromGitHub,
  enableLTO ? true,
  nrxAlias ? true,
}:
rustPlatform.buildRustPackage rec {
  pname = "nrr";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "ryanccn";
    repo = "nrr";
    rev = "v${version}";
    hash = "sha256-RBKFDm6MpK2lDCUvbX0EFEuOASKtHM+5QknWM0A6AKE=";
  };

  cargoHash = "sha256-DiapeSFfsmox+Utx9uW/8/veEQcnWmoaETLNyffpv64=";

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
