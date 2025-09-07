{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  libgit2,
  zlib,
  vimUtils,
  nix-update-script,
}:

let
  version = "0.54";

  src = fetchFromGitHub {
    owner = "liuchengxu";
    repo = "vim-clap";
    tag = "v${version}";
    hash = "sha256-rhCum59GCIAwdi5QgSaPfrALelAIMncNetu81i53Q8c=";
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

    cargoHash = "sha256-FEeSwa8KmIyfhWAU9Dpric6uB2e0yK+Tig/k2zwq2Rg=";

    nativeBuildInputs = [
      pkg-config
    ];

    # Remove after next release
    cargoPatches = [
      (fetchpatch {
        name = "rust-1.80";
        url = "https://github.com/liuchengxu/vim-clap/commit/3e8d001f5c9be10e4bb680a1d409326902c96c10.patch";
        hash = "sha256-qMflfQEssH4OGXmLFUcQwzbYWgPD0S/pClb35ZRUaPM=";
      })
    ];

    buildInputs = [
      libgit2
      zlib
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
