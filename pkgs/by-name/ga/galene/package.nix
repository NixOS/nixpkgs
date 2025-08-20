{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "galene";
  version = "0.96";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene";
    rev = "galene-${version}";
    hash = "sha256-E/xFh60Fzy/bRX414N1Juc7j4D8fN8CEDYPOUrNp5/4=";
  };

  vendorHash = "sha256-LDLKjD4qYn/Aae6GUX6gZ57+MUfKc058H+YHM0bNZV0=";

  ldflags = [ "-s" "-w" ];
  preCheck = "export TZ=UTC";

  outputs = [ "out" "static" ];

  postInstall = ''
    mkdir $static
    cp -r ./static $static
  '';

  meta = with lib; {
    description = "Videoconferencing server that is easy to deploy, written in Go";
    homepage = "https://github.com/jech/galene";
    changelog = "https://github.com/jech/galene/raw/galene-${version}/CHANGES";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rgrunbla erdnaxe ];
  };
}
