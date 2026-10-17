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
  version = "0.75.0";

  src = fetchFromGitHub {
    owner = "kyu08";
    repo = "fzf-make";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0/z27cTelsJPUqWWf+UMcplfsPYSoNcNUMlYCrKBCPQ=";
  };

  cargoHash = "sha256-Uv8NB9S5ii0bDuX6sqffQE5e3mXJB6UItiA3ijFdWaM=";

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
