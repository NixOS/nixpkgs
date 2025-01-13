{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rnr";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ismaelgv";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uuM8zh0wFSsySedXmdm8WGGR4HmUc5TCZ6socdztrZI=";
  };

  cargoHash = "sha256-R+4BvRCWYWVV2oT9+vifWvnoWEglfVMeFCPM0AjMQPE=";

  meta = with lib; {
    description = "Command-line tool to batch rename files and directories";
    mainProgram = "rnr";
    homepage = "https://github.com/ismaelgv/rnr";
    changelog = "https://github.com/ismaelgv/rnr/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
