{
  lib,
  buildGoModule,
  fetchFromGitHub,
  darwin,
  stdenv,
}:
buildGoModule rec {
  pname = "gptscript";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "gptscript-ai";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-jNscG3tET7Keg5tTkRKnnaDwXeB9xNqi3ggOnN3OI7E=";
  };

  vendorHash = "sha256-KOgCYN3whi8gI7cF62uHXkJfLKA5QzfwlFjYh2Q7PlI=";

  propagatedBuildInputs = with darwin;
    lib.optionals stdenv.isDarwin [Security];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gptscript-ai/gptscript/pkg/version.Tag=v${version}"
  ];

  # Requires network access
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/gptscript-ai/gptscript";
    changelog = "https://github.com/gptscript-ai/gptscript/releases/tag/v${version}";
    description = "Build AI assistants that interact with your systems";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ jamiemagee ];
    mainProgram = "gptscript";
  };
}
