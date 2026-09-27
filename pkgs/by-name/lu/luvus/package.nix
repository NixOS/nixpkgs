{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  versionCheckHook,
  git,
  gh,
  openssh,
  bashInteractive,
  coreutils,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "luvus";
  version = "0.11.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "RizRiyz";
    repo = "luvus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aKL/5N0E91IVIG7drMwKozNQy/bzy/78VdNCl67Dunc=";
  };

  cargoHash = "sha256-CqRDKuHC5kwIdGXLdpehBRoV1kE+Vj2Mj7xix3anz9k=";

  nativeBuildInputs = [ makeWrapper ];

  # The test suite spawns real PTYs, `ps`, and child processes and reads $HOME,
  # all awkward inside the Nix sandbox; upstream CI runs the full suite on every
  # push, so the package build just compiles the release binary.
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postFixup = ''
    wrapProgram $out/bin/luvus \
      --suffix PATH : ${
        lib.makeBinPath [
          git
          gh
          openssh
        ]
      } \
      --prefix PATH : ${
        lib.makeBinPath [
          bashInteractive
          coreutils
        ]
      }
  '';

  meta = {
    description = "Mission control for your AI coding agents";
    homepage = "https://luvus.dev";
    changelog = "https://github.com/RizRiyz/luvus/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    mainProgram = "luvus";
    maintainers = with lib.maintainers; [ rizriyz ];
    platforms = lib.platforms.unix;
  };
})
