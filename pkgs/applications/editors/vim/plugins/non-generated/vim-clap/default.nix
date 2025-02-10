{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  zlib,
  stdenv,
  darwin,
  vimUtils,
  nix-update-script,
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

    useFetchCargoVendor = true;
    cargoHash = "sha256-FEeSwa8KmIyfhWAU9Dpric6uB2e0yK+Tig/k2zwq2Rg=";

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs =
      [
        libgit2
        zlib
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
