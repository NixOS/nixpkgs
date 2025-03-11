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
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "pulp-platform";
    repo = "bender";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eC4BY3ri73vgEtcXoPQ5NDknjZcPrKOzLo2vXWj4Adg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fV4pWSRNlXCdnpeDgg3QW8s1Ixd1LEY8qP/Pb4t5xdc=";

  nativeCheckInputs = [ gitMinimal ];
  postCheck = ''
    patchShebangs --build tests
    BENDER="target/${target}/$cargoBuildType/bender" tests/run_all.sh
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
