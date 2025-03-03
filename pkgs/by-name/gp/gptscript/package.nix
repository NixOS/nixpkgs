{
  lib,
  buildGoModule,
  fetchFromGitHub,
  darwin,
  stdenv,
}:
buildGoModule rec {
  pname = "gptscript";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "gptscript-ai";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9wyDcvY5JCjtvx6XtvHwOsZLCiN1fRn0wBGaIaw2iRQ=";
  };

  vendorHash = "sha256-ajglXWGJhSJtcrbSBmxmriXFTT+Vb4xYq0Ec9SYRlQk=";

  propagatedBuildInputs = with darwin; lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

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
