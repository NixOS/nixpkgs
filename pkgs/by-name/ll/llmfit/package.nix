{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "llmfit";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "AlexsJones";
    repo = "llmfit";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-FtndcSIPQHoAOGhESKXqroFpuYvmGDoK/ns+W0DsHsk=";
  };

  cargoHash = "sha256-LJz4rxdDm8FD+8by8H0/AgkMc6zH5pqc3qC+rtmfBAU=";

  meta = {
    description = "Find what runs on your hardware";
    homepage = "https://github.com/AlexsJones/llmfit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "llmfit";
  };
})
