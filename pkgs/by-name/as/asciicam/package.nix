{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "asciicam";
  version = "0-unstable-2022-06-25";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "asciicam";
    rev = "e17a9333fdfe5f7c4c610c6aac23419fe2cba7a9";
    hash = "sha256-BzMoyqp2chlQGA2Q9i8koXlH4pemN6q3P8gwM1i8ZAU=";
  };

  vendorHash = "sha256-Qnt1wo/yKC3Ce4JoZBIWtXyzlkh4bWz9vyE349iRsjk=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Displays your webcam on the terminal";
    homepage = "https://github.com/muesli/asciicam";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "asciicam";
  };
}
