{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "easyjson";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "mailru";
    repo = "easyjson";
    rev = "v${version}";
    sha256 = "sha256-m2WZwi6TM6hiBlCQOe+rxF5z3vvnYqtHQX8d7y5NLgI=";
  };
  vendorHash = "sha256-BsksTYmfPQezbWfIWX0NhuMbH4VvktrEx06C2Nb/FYE=";

  subPackages = [ "easyjson" ];

  meta = with lib; {
    homepage = "https://github.com/mailru/easyjson";
    description = "Fast JSON serializer for Go";
    mainProgram = "easyjson";
    license = licenses.mit;
    maintainers = with maintainers; [ Madouura ];
  };
}
