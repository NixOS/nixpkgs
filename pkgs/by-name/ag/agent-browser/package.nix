{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agent-browser";
  version = "0.20.11";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "agent-browser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-erjY+FWrDzw1Aj4SpsJdhHnbKF06CH0NFfggRVJDbYA=";
  };

  sourceRoot = "source/cli";

  cargoHash = "sha256-NKRznFnroy1QuRecUaAqpCngvFKP7wLdy0wVFrYYI+c=";

  # Tests require env vars and filesystem access unavailable in the sandbox
  doCheck = false;

  meta = {
    description = "Fast browser automation CLI for AI agents";
    homepage = "https://github.com/vercel-labs/agent-browser";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ domenkozar ];
    mainProgram = "agent-browser";
  };
})
