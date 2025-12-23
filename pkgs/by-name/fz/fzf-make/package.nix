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
  version = "0.65.0";

  src = fetchFromGitHub {
    owner = "kyu08";
    repo = "fzf-make";
    tag = "v${version}";
    hash = "sha256-KL2dRyfwwa365hEMeVixAP9DFx3QObJVeesj95tOUmo=";
  };

  cargoHash = "sha256-QaR0Se8ecNKj7OcngwEOrK63VT200D+/Xm3RaIiLdec=";

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
