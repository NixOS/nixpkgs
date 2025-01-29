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
  version = "0.56.0";

  src = fetchFromGitHub {
    owner = "kyu08";
    repo = "fzf-make";
    rev = "v${version}";
    hash = "sha256-OioPl2uJVepMsR1PYHpASj3yQ10bCaGFxI1wQR61EsA=";
  };

  cargoHash = "sha256-Y1kFbJi+AB4uROieZERafU82RWm2AGQseDUuVzJn3NA=";

  useFetchCargoVendor = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/fzf-make \
      --set SHELL ${runtimeShell} \
      --suffix PATH : ${lib.makeBinPath [ bat gnugrep gnumake ]}
  '';

  meta = {
    description = "Fuzzy finder for Makefile";
    inherit (src.meta) homepage;
    changelog = "https://github.com/kyu08/fzf-make/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda sigmanificient ];
    mainProgram = "fzf-make";
  };
}
