{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "models";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "arimxyer";
    repo = "models";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AsSuxRXJvYtJkVISYyZ7lPz/ouMyDFBv3EGVi12WJ74=";
  };

  cargoHash = "sha256-qAomuqDkcj/t4LVaRGIeX1+j6MEgv1rSH3JtCTHm2As=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI and CLI for browsing AI models, benchmarks, coding agents, and statuses for AI providers";
    homepage = "https://github.com/arimxyer/models";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nemeott ];
    mainProgram = "models";
  };
})
