{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  nixel,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixel";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = "nixel";
    rev = finalAttrs.version;
    hash = "sha256-wIXZd8iujLqbgbV+abWmIfjDgQ8i6nyE5jTAs3OczXM=";
  };

  cargoHash = "sha256-y0xqMLvtYmmEArpCF1JN5RSaIV/udNKf1xSBM4XyV8M=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  # bindgen 0.63 (locked in Cargo.lock) does not emit functions declared
  # inside `extern "C" {}` blocks in C++ mode, so `ffi::parse` is missing.
  # The definition in src/utils.cc keeps `extern "C"`, so linking is unchanged.
  postPatch = ''
    substituteInPlace src/types.hh \
      --replace-fail 'extern "C" {' "" \
      --replace-fail 'size_t len);
    }' 'size_t len);'
  '';

  # Let's test it runs
  passthru.tests = {
    version = testers.testVersion { package = nixel; };
  };

  meta = {
    description = "Parser for the Nix Expressions Language";
    mainProgram = "nixel";
    homepage = "https://github.com/kamadorueda/nixel";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
})
