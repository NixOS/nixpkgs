{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
  pkg-config,
  libgit2,
  zlib,
  vimUtils,
  nix-update-script,
}:

let
  version = "0.55";

  src = fetchFromGitHub {
    owner = "liuchengxu";
    repo = "vim-clap";
    tag = "v${version}";
    hash = "sha256-vtIA2URex7DOBIZ9KW++/ziqhVd/GDJOKYTUULdMqGc=";
  };

  meta = {
    description = "Modern performant fuzzy picker for Vim and NeoVim";
    mainProgram = "maple";
    homepage = "https://github.com/liuchengxu/vim-clap";
    changelog = "https://github.com/liuchengxu/vim-clap/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };

  maple = rustPlatform.buildRustPackage {
    pname = "maple";
    inherit version src meta;

    cargoHash = "sha256-RMDlLpPWDLHCRWLz7NAAQhp6FhKA7aNYqx9MCqR8vYM=";

    cargoPatches = [
      # TODO: remove after next release
      # https://github.com/liuchengxu/vim-clap/issues/1121
      (fetchpatch2 {
        url = "https://github.com/liuchengxu/vim-clap/commit/b95d4a3f9371271096553df1240b3f59a2dc99ec.patch?full_index=1";
        hash = "sha256-FvGuSFHMOprPSUlR82SR/IMNDd3RaGECQm2wfPCOW4Y=";
      })
    ];

    nativeBuildInputs = [
      pkg-config
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
