{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nanoda-lib";
  version = "0.4.19";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ammkrn";
    repo = "nanoda_lib";
    # https://github.com/leanprover/lean4/blob/v{version}/src/CMakeLists.txt
    rev = "831ba4e661ab5af55a6b1dcf69fa86c0f81f1332";
    hash = "sha256-gp8Aul2AyRh926mdmQbNcpqJ/FNzbTmA4DJUHjrc73s=";
  };

  cargoHash = "sha256-BH7GdzOWBPB4cWOSQ1Dhr4XMKVqNeVmG9F9HH5UZuhk=";

  meta = {
    description = "Library implementing type inference/checking functionality based on the Lean theorem prover";
    homepage = "https://github.com/ammkrn/nanoda_lib";
    changelog = "https://github.com/ammkrn/nanoda_lib/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      drupol
      stephen-huan
    ];
    mainProgram = "nanoda_bin";
  };
})
