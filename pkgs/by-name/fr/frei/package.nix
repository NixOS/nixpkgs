{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "frei";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "alexcoder04";
    repo = "frei";
    rev = "v${version}";
    sha256 = "sha256-jCUr3fREawA0J8Q0U07wCpBQrjPyH0l/6tih6C9kJWc=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "Modern replacement for free";
    homepage = "https://github.com/alexcoder04/frei";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ infinidoge ];
    mainProgram = "frei";
  };
}
