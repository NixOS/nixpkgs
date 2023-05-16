{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, zlib
, stdenv
, darwin
, vimUtils
<<<<<<< HEAD
, nix-update-script
}:

let
  version = "0.45";
=======
}:

let
  version = "0.43";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "liuchengxu";
    repo = "vim-clap";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-espFos1Mrxdq2p+qi0ooTWAV8EgV/lTx9KuP3GkMWos=";
=======
    hash = "sha256-UHsDSah8Fn67w11s/lwL76qbGPqXhz6tYlBBuiqTNXs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.Security
    ];
  };
in

vimUtils.buildVimPluginFrom2Nix {
  pname = "vim-clap";
  inherit version src meta;

  postInstall = ''
    ln -s ${maple}/bin/maple $out/bin/maple
  '';

  passthru = {
    inherit maple;
<<<<<<< HEAD
    updateScript = nix-update-script {
      attrPath = "vimPlugins.vim-clap.maple";
    };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
