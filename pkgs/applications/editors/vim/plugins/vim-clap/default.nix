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
  version = "0.53";

  src = fetchFromGitHub {
    owner = "liuchengxu";
    repo = "vim-clap";
    rev = "v${version}";
    hash = "sha256-0D9HMFh0G9Dq78v/Aau7VXN9jBad6ZevqTCjx7FT9Yw=";
  };

  meta = with lib; {
    description = "A modern performant fuzzy picker for Vim and NeoVim";
    mainProgram = "maple";
    homepage = "https://github.com/liuchengxu/vim-clap";
    changelog = "https://github.com/liuchengxu/vim-clap/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
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
