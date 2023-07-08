{ lib, fetchFromGitHub }:
rec {
  version = "1.4.12";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    hash = "sha256-ZGPXcpicDYCE+J9mC2Dk/Ds2NYfUETuKXqHxpAGH86w=";
  };

  yarnHash = "sha256-LJ0uL66tcK6zL8Mkd2UB8dHsslMTtf8wQmgbZdvOT6s=";

  meta = with lib; {
    homepage = "https://tandoor.dev/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ambroisie ];
  };
}
