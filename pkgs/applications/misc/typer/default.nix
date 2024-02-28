{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule {
  pname = "typer";
  version = "unstable-2023-02-08";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "typer";
    rev = "02aa80b3be8a6c2c9d08d9a56b3fe784adf00933";
    hash = "sha256-J3wTqWxHEQz1AAt7DfUmpgc7wmfILBtyHuDrmqN96fI=";
  };

  vendorHash = "sha256-t4zim6WhqGAf1zHmmbJbpVvQcE/aoNL7ZLdjU7f3rp8=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Typing test in your terminal";
    homepage = "https://github.com/maaslalani/typer";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "typer";
  };
}
