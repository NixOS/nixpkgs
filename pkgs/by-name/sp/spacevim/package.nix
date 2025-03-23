{
  fetchFromGitHub,
  formats,
  fzf,
  git,
  lib,
  makeWrapper,
  neovim,
  nix-update-script,
  ripgrep,
  runCommand,
  stdenv,
  vim-full,
  spacevim_config ? import ./init.nix,
}:

let
  format = formats.toml { };
  spacevimdir = runCommand "SpaceVim.d" { } ''
    mkdir -p $out
    cp ${format.generate "init.toml" spacevim_config} $out/init.toml
  '';
in
stdenv.mkDerivation rec {
  pname = "spacevim";
  version = "2.4.0";
  src = fetchFromGitHub {
    owner = "SpaceVim";
    repo = "SpaceVim";
    rev = "v${version}";
    hash = "sha256-qiNadhQJjU9RY14X8+pd4Ul+NLoNqbxuh3Kenw1dHDc=";
  };

  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin

    cp -r $(pwd) $out/SpaceVim

    # trailing slash very important for SPACEVIMDIR
    makeWrapper "${vim-full}/bin/vim" "$out/bin/spacevim" \
        --add-flags "-u $out/SpaceVim/vimrc" --set SPACEVIMDIR "${spacevimdir}/" \
        --prefix PATH : ${
          lib.makeBinPath [
            fzf
            git
            ripgrep
          ]
        }
    makeWrapper "${neovim}/bin/nvim" "$out/bin/spacenvim" \
        --add-flags "-u $out/SpaceVim/init.vim" --set SPACEVIMDIR "${spacevimdir}/" \
        --prefix PATH : ${
          lib.makeBinPath [
            fzf
            git
            ripgrep
          ]
        }
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modular Vim/Neovim configuration";
    longDescription = ''
      SpaceVim is a modular configuration of Vim and Neovim. It's inspired by
      spacemacs. It manages collections of plugins in layers, which help to
      collect related packages together to provide features. This approach
      helps keep the configuration organized and reduces overhead for the user
      by keeping them from having to think about what packages to install.
    '';
    homepage = "https://spacevim.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.perchun ];
    platforms = lib.platforms.all;
    mainProgram = "spacevim";
  };
}
