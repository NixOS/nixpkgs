{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
}:
let
  target = stdenv.hostPlatform.rust.cargoShortTarget;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bender";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "pulp-platform";
    repo = "bender";
    tag = "v${finalAttrs.version}";
    hash = "sha256-91VS3cXscq2Lu2oP3b5WJ1sp7HhMhw+BgOVTFsC6pnc=";
  };

  cargoHash = "sha256-lgEg9Sf5n3zbm/vbn+vLBGmqBOA1aTcCBCFYrzwPVCk=";

  nativeCheckInputs = [ gitMinimal ];
  postCheck = ''
    patchShebangs --build tests
    BENDER="$PWD/target/${target}/$cargoBuildType/bender" tests/run_all.sh
  '';

  meta = {
    description = "Dependency management tool for hardware projects";
    homepage = "https://github.com/pulp-platform/bender";
    changelog = "https://github.com/pulp-platform/bender/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ Liamolucko ];
    mainProgram = "bender";
    platforms = lib.platforms.all;
  };
})
