{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "huniq";
  version = "2.7.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-5GvHM05qY/Jj1mPYwn88Zybn6Nn5nJIaw0XP8iCcrwE=";
  };

  cargoHash = "sha256-pE2LmoUUrIiKECte97AO2i5Ef22/qZwby/EDxTUr0x4=";

  meta = {
    description = "Command line utility to remove duplicates from the given input";
    mainProgram = "huniq";
    homepage = "https://github.com/koraa/huniq";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
