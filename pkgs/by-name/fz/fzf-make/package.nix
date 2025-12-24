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

rustPlatform.buildRustPackage rec {
  pname = "fzf-make";
  version = "0.66.0";

  src = fetchFromGitHub {
    owner = "kyu08";
    repo = "fzf-make";
    tag = "v${version}";
    hash = "sha256-2lJVE1+IGw5Yh0y6u7uW8ZYyM/0D3OwwtG36FLmBet4=";
  };

  cargoHash = "sha256-2HW40aqJgDIr5QXusPAe89hQtC7L0DmdPEqQShOxiDc=";

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
    inherit (src.meta) homepage;
    changelog = "https://github.com/kyu08/fzf-make/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sigmanificient
    ];
    mainProgram = "fzf-make";
  };
}
