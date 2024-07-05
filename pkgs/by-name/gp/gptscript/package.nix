{
  lib,
  buildGo122Module,
  fetchFromGitHub,
  darwin,
  stdenv,
}:
buildGo122Module rec {
  pname = "gptscript";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "gptscript-ai";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-BqGoIDFquVMGMkKe2IO3Se4IeqgVSqjv00gfhJf8evs=";
  };

  vendorHash = "sha256-oI2agy8FOyoNl0zQzvXMsHY5tG1QNvkQf+n2GVGyNz8=";

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
    changelog = "https://github.com/gptscript-ai/gptscript/releases/tag/v{version}";
    description = "Build AI assistants that interact with your systems";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ jamiemagee ];
    mainProgram = "gptscript";
  };
}
