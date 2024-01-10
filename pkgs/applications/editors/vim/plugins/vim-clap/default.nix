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
  version = "0.47";

  src = fetchFromGitHub {
    owner = "liuchengxu";
    repo = "vim-clap";
    rev = "v${version}";
    hash = "sha256-CYv5AZsGvN2dtN7t58b50a8PH7804Lnm4d4wAX6Mm5Q=";
  };

  meta = with lib; {
    description = "A modern performant fuzzy picker for Vim and NeoVim";
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
      };
    };

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      libgit2
      zlib
    ] ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreServices
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
