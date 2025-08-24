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
  version = "0.60.0";

  src = fetchFromGitHub {
    owner = "kyu08";
    repo = "fzf-make";
    rev = "v${version}";
    hash = "sha256-5/hGTU8jQQvGp0c4FpB29H9wBbae8lVjlohivcVFFwI=";
  };

  cargoHash = "sha256-Cz0qR24zRXivF3pAo95GNnx8bjUKK96GFnntb68Lz1U=";

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
    changelog = "https://github.com/kyu08/fzf-make/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      sigmanificient
    ];
    mainProgram = "fzf-make";
  };
}
