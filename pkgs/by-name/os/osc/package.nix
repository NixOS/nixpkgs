{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "osc";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "theimpostor";
    repo = "osc";
    rev = "v${version}";
    hash = "sha256-KGB7mizex4RSkxlaeikS1BEzkNkLAlhSM7J7upbDxQI=";
  };

  vendorHash = "sha256-VEzVd1LViMtqhQaltvGuupEemV/2ewMuVYjGbKOi0iw=";

  nativeBuildInputs =
    [
    ];

  meta = with lib; {
    description = "Access the system clipboard from anywhere using the ANSI OSC52 sequence";
    homepage = "https://github.com/theimpostor/osc";
    changelog = "https://github.com/theimpostor/osc/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ graham33 ];
    mainProgram = "osc";
  };
}
