{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "confetty";
  version = "unstable-2022-11-05";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "confetty";
    rev = "6c6f1b5b605f78c3ed3bab2d2a1357c0dd794221";
    hash = "sha256-1BAszv9I2JDflWyHuAlbJo7+oI7BI/TL10uFIYa8mLk=";
  };

  vendorHash = "sha256-RymdnueY674Zd231O8CIw/TEIDaWDzc+AaI6yk9hFgc=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Confetti in your TTY";
    homepage = "https://github.com/maaslalani/confetty";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "confetty";
  };
}
