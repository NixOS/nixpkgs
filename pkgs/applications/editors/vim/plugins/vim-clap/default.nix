{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, zlib
, stdenv
, darwin
, vimUtils
, nix-update-script
}:

let
  version = "0.54-unstable-2024-08-11";

  src = fetchFromGitHub {
    owner = "liuchengxu";
    repo = "vim-clap";
    rev = "3e8d001f5c9be10e4bb680a1d409326902c96c10";
    hash = "sha256-7bgbKYjJX2Tfprb69/imyvhsCsurrmPWBXVVLX+ZMnM=";
  };

  meta = with lib; {
    description = "Modern performant fuzzy picker for Vim and NeoVim";
    mainProgram = "maple";
    homepage = "https://github.com/liuchengxu/vim-clap";
    changelog = "https://github.com/liuchengxu/vim-clap/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };

  maple = rustPlatform.buildRustPackage {
    pname = "maple";
    inherit version src meta;

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "subprocess-0.2.10" = "sha256-WcGrJ103ofGlQwi32kRGM3Z+uvKSCFBmFZbZXAtuWwM=";
        "tree-sitter-dockerfile-0.1.0" = "sha256-K+duK3HcxlVgbLXBos3MUxyfnTywcHX6JM4Do0qAJO0=";
        "tree-sitter-vim-0.3.1-dev.0" = "sha256-CWxZ28LdptiMNO2VIk+Ny/DhQXdN604EuqRIb9oaCmI=";
      };
    };

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      libgit2
      zlib
    ] ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];
  };
in

vimUtils.buildVimPlugin {
  pname = "vim-clap";
  inherit version src meta;

  postInstall = ''
    ln -s ${maple}/bin/maple $out/bin/maple
  '';

  passthru = {
    inherit maple;
    updateScript = nix-update-script {
      attrPath = "vimPlugins.vim-clap.maple";
    };
  };
}
