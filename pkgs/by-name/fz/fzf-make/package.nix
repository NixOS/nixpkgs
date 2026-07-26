{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  runtimeShell,
  bat,
  gnugrep,
  gnumake,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fzf-make";
  version = "0.70.0";

  src = fetchFromGitHub {
    owner = "kyu08";
    repo = "fzf-make";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LRLwHCHsXW0SZ8X+7719vaCBQDx9fjiMvF2oma8u41w=";
  };

  cargoHash = "sha256-bNp4P/Hag4br28rrfeNIUFQqKNKa/Gin79gQR6sg8W8=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/fzf-make \
      --set SHELL ${runtimeShell} \
      --suffix PATH : ${
        lib.makeBinPath [
          bat
          gnugrep
          gnumake
        ]
      }
  '';

  meta = {
    description = "Fuzzy finder for Makefile";
    inherit (finalAttrs.src.meta) homepage;
    changelog = "https://github.com/kyu08/fzf-make/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sigmanificient
    ];
    mainProgram = "fzf-make";
  };
})
