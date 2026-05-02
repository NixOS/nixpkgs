{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ccmeter";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "hmenzagh";
    repo = "CCMeter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LdTAdYqdp1echgvYpODuxWQQH2+a6QwJdRUNfm/u35I=";
  };

  cargoHash = "sha256-ehYaekglA3jMJySFAJv8jsuT1ivr1L87oUuCFJkvtmw=";

  meta = {
    description = "TUI dashboard for tracking Claude Code usage and costs";
    homepage = "https://github.com/hmenzagh/CCMeter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
    platforms = lib.platforms.unix;
    mainProgram = "ccmeter";
  };
})
