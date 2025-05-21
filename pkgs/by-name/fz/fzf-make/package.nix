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
  version = "0.59.0";

  src = fetchFromGitHub {
    owner = "kyu08";
    repo = "fzf-make";
    rev = "v${version}";
    hash = "sha256-KH2tcQngc3LVgybdmw/obhbMiLoj3GZVnyWaDXXBJNs=";
  };

  cargoHash = "sha256-GCnzqfTBvckWtgXCz0Yd0SHh82bC3bS7uLOAdY37z+s=";

  useFetchCargoVendor = true;

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
