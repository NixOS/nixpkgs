{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rep-grep";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "robenkleene";
    repo = "rep-grep";
    tag = finalAttrs.version;
    hash = "sha256-GJXpzqc9reFFyZWPsaiohFsPj3PseijSLn6Td8Ouidk=";
  };

  cargoHash = "sha256-ugQxJsu/U7O3S8SQwhGGDAdEIDesW7JbwFBkNYRe13w=";

  meta = {
    description = "Command-line utility that takes grep-formatted lines and performs a find-and-replace on them";
    homepage = "https://github.com/robenkleene/rep-grep";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philiptaron ];
    mainProgram = "rep";
  };
})
