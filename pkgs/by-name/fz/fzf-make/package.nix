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
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "kyu08";
    repo = "fzf-make";
    rev = "v${version}";
    hash = "sha256-JHquE35qe1nJFJ+0gniG72o1DrGLZSZ0do5oPHgYbHU=";
  };

  cargoHash = "sha256-61I6OiEP0t9DAF0jnIEyGRTpPBU65zz/W6mAo7XelVo=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/fzf-make \
      --set SHELL ${runtimeShell} \
      --suffix PATH : ${lib.makeBinPath [ bat gnugrep gnumake ]}
  '';

  meta = with lib; {
    description = "Fuzzy finder for Makefile";
    homepage = "https://github.com/kyu08/fzf-make";
    changelog = "https://github.com/kyu08/fzf-make/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda sigmanificient ];
    mainProgram = "fzf-make";
  };
}
