{
  lib,
  buildGoModule,
  fetchFromGitHub,
  darwin,
  stdenv,
}:
buildGoModule rec {
  pname = "gptscript";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "gptscript-ai";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-s7AKpoIFRcZfAM6K1MMovzOqgXdAWtnnFR3m+84L3rQ=";
  };

  vendorHash = "sha256-Kf/ckUuG+SA8WQN2MKL+Xrz91RGPuA7X2/MjryRXsts=";

  propagatedBuildInputs = with darwin;
    lib.optionals stdenv.hostPlatform.isDarwin [Security];

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
