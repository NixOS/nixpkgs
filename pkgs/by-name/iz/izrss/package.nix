{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:
let
  version = "0.1.2";
in
buildGoModule {
  pname = "izrss";
  inherit version;

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "izrss";
    tag = "v${version}";
    hash = "sha256-t/YvSl6JoYLHsCPkRlbaM8OlAMQc83cb4sOKF7S/CFw=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-bB6oxIbFqY0rPoGetIGfKEdfPsX9cqeb9WcjtgjAAJA=";

  meta = {
    description = "RSS feed reader for the terminal written in Go";
    changelog = "https://github.com/isabelroses/izrss/releases/v${version}";
    homepage = "https://github.com/isabelroses/izrss";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      isabelroses
      luftmensch-luftmensch
    ];
    mainProgram = "izrss";
  };
}
