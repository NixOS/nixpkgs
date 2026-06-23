{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "efmt";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "sile";
    repo = "efmt";
    rev = finalAttrs.version;
    hash = "sha256-Qk33fKOQmBnT0D3/VEF8txm0GIPLziISkqxGjn2gWdM=";
  };

  cargoHash = "sha256-WW6vh/Efv1NweVNfgNDyRVM8cWOPYA2py5jEcL358dk=";

  meta = {
    description = "Erlang code formatter";
    homepage = "https://github.com/sile/efmt";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ haruki7049 ];
    mainProgram = "efmt";
  };
})
