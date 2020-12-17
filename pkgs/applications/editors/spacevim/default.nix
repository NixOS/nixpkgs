{ ripgrep, gitAndTools, fzf, makeWrapper, vim_configurable, vimPlugins, fetchFromGitHub, writeTextDir
, stdenv, runCommandNoCC, remarshal, formats, spacevim_config ? import ./init.nix }:
with stdenv;
let
  format = formats.toml {};
  vim-customized = vim_configurable.customize {
    name = "vim";
    # Not clear at the moment how to import plugins such that
    # SpaceVim finds them and does not auto download them to
    # ~/.cache/vimfiles/repos
    vimrcConfig.packages.myVimPackage = with vimPlugins; { start = [ ]; };
  };
  spacevimdir = format.generate "init.toml" spacevim_config;
in mkDerivation rec {
  pname = "spacevim";
  version = "1.5.0";
  src = fetchFromGitHub {
    owner = "SpaceVim";
    repo = "SpaceVim";
    rev = "v${version}";
    sha256 = "1xw4l262x7wzs1m65bddwqf3qx4254ykddsw3c3p844pb3mzqhh7";
  };

  nativeBuildInputs = [ makeWrapper vim-customized];
  buildInputs = [ vim-customized ];

  buildPhase = ''
    # generate the helptags
    vim -u NONE -c "helptags $(pwd)/doc" -c q
  '';

  patches = [ ./helptags.patch ];

  installPhase = ''
    mkdir -p $out/bin

    cp -r $(pwd) $out/SpaceVim

    # trailing slash very important for SPACEVIMDIR
    makeWrapper "${vim-customized}/bin/vim" "$out/bin/spacevim" \
        --add-flags "-u $out/SpaceVim/vimrc" --set SPACEVIMDIR "${spacevimdir}/" \
        --prefix PATH : ${lib.makeBinPath [ fzf gitAndTools.git ripgrep]}
  '';

  meta = with stdenv.lib; {
    description = "Modern Vim distribution";
    longDescription = ''
      SpaceVim is a distribution of the Vim editor that’s inspired by spacemacs.
    '';
    homepage = "https://spacevim.org/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.fzakaria ];
    platforms = platforms.all;
  };
}
