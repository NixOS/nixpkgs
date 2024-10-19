{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "desed";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "SoptikHa2";
    repo = "desed";
    rev = "refs/tags/v${version}";
    hash = "sha256-FL9w+XdClLBCRp+cLqDzTVj8j9LMUp8jZ6hiG4KvIds=";
  };

  cargoHash = "sha256-inH8fUpUR0WXYY2JX72evZqVp3GlnGKBBlrbai/fU6U=";

  meta = {
    changelog = "https://github.com/SoptikHa2/desed/releases/tag/v${version}";
    description = "Debugger for Sed: demystify and debug your sed scripts, from comfort of your terminal. ";
    homepage = "https://github.com/SoptikHa2/desed";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ vinylen ];
    mainProgram = "desed";
  };
}
