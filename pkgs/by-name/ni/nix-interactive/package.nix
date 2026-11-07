{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  nvd,
  git,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-interactive";
  version = "0.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Geekiac";
    repo = "nix-interactive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HUa+A06FF5xY/I5KV1nJ41MjFksF9XWgeqtVH0huTlo=";
  };

  cargoHash = "sha256-F+eQngeaOdl2/ND+/0UaKMMGg2alfR7BzSDnuEtN+5w=";

  nativeBuildInputs = [ makeWrapper ];

  # nvd and git back the viewer's nvd and commit views. `nix` itself is left to the
  # user's PATH so it matches their daemon.
  postInstall = ''
    wrapProgram $out/bin/nixi --suffix PATH : ${
      lib.makeBinPath [
        nvd
        git
      ]
    }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactive historical diff viewer for Nix generations";
    homepage = "https://github.com/Geekiac/nix-interactive";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ geekiac ];
    mainProgram = "nixi";
    platforms = lib.platforms.unix;
  };
})
