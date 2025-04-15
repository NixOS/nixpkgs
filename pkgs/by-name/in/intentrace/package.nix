{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

let
  version = "0.8.0";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "intentrace";

  src = fetchFromGitHub {
    owner = "sectordistrict";
    repo = "intentrace";
    tag = "v${version}";
    hash = "sha256-ONOYxtY4e+lxjp1nQ7L8O0xwhEqS3f56KmDFtNo4s80=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-EyOCs7PpsTd2NQbqcXb4ZlZPPTvHQlraxy5liTA2hcE=";

  meta = {
    description = "Prettified Linux syscall tracing tool (like strace)";
    homepage = "https://github.com/sectordistrict/intentrace";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "intentrace";
    maintainers = with lib.maintainers; [
      cloudripper
      jk
    ];
  };
}
