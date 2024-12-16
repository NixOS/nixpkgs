{ lib
, rustPlatform
, fetchFromGitHub
, makeBinaryWrapper
, runtimeShell
, bat
, gnugrep
, gnumake
}:

rustPlatform.buildRustPackage rec {
  pname = "fzf-make";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "kyu08";
    repo = "fzf-make";
    rev = "v${version}";
    hash = "sha256-msSiVlz6Aey8Q+NjtKl58TOkYtPIzw3733kVGs9/8UQ=";
  };

  cargoHash = "sha256-q67UAAVvc070eArfMo4r/UcUUjODuR/vMukiA4ylQ5w=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/fzf-make \
      --set SHELL ${runtimeShell} \
      --suffix PATH : ${lib.makeBinPath [ bat gnugrep gnumake ]}
  '';

  meta = {
    description = "Fuzzy finder for Makefile";
    homepage = "https://github.com/kyu08/fzf-make";
    changelog = "https://github.com/kyu08/fzf-make/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda sigmanificient ];
    mainProgram = "fzf-make";
  };
}
