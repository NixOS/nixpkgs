{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "air";
  version = "1.61.1";

  src = fetchFromGitHub {
    owner = "air-verse";
    repo = "air";
    rev = "v${version}";
    hash = "sha256-IwPUbz3JYKz0TeK/kbEUzqFp0l8u/AFu9KEAyR8zlSQ=";
  };

  vendorHash = "sha256-BY2KnAwlrIyqSHWFLD0QU93EXAv4ta/ibvYWiHXvYMc=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.airVersion=${version}"
  ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Live reload for Go apps";
    mainProgram = "air";
    homepage = "https://github.com/air-verse/air";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Gonzih ];
  };
}
