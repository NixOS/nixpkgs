{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  pik,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pik";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jacek-kurlit";
    repo = "pik";
    rev = finalAttrs.version;
    hash = "sha256-YachIoJeMDJPBvmucALRvyhIwFpMqatesKn3mdrGguE=";
  };

  cargoHash = "sha256-gHx6G3MUbv/JCbFGdAUm2ep11d0ksVLlEbSBCtXm7ls=";

  passthru.tests.version = testers.testVersion { package = pik; };

  meta = {
    description = "Process Interactive Kill";
    longDescription = ''
      Process Interactive Kill is a command line tool that helps to find and kill process.
      It works like pkill command but search is interactive.
    '';
    homepage = "https://github.com/jacek-kurlit/pik";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ bew ];
    mainProgram = "pik";
  };
})
