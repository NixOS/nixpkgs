{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  fd,
  ripgrep,
}:

rustPlatform.buildRustPackage rec {
  pname = "kmp-lsp";
  version = "0.20.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Hessesian";
    repo = "kmp-lsp";
    tag = "v${version}";
    hash = "sha256-78ooVOoySdMZAhgpDJZjqEaOEIzSPZ1mC2M79OSCt4o=";
  };

  cargoHash = "sha256-28SAdHRlOMyMgPfYzYtjfqPDCcei4uPk0X/mc4SIeYM=";

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [
    fd
    ripgrep
  ];

  postFixup = ''
    wrapProgram $out/bin/kmp-lsp \
      --prefix PATH : ${
        lib.makeBinPath [
          fd
          ripgrep
        ]
      }
  '';

  meta = {
    description = "Fast, low-memory LSP server for Kotlin, Java, and Swift";
    homepage = "https://github.com/Hessesian/kmp-lsp";
    mainProgram = "kmp-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ BeLeap ];
  };
}
