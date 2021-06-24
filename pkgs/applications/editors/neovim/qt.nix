{ lib, stdenv, mkDerivation, fetchFromGitHub, cmake, doxygen, makeWrapper
, msgpack, neovim, pythonPackages, qtbase, neovim-qt-unwrapped }:

let
  unwrapped = neovim-qt-unwrapped;
in
stdenv.mkDerivation {
  pname = "neovim-qt";
  version = unwrapped.version;
  buildCommand = if stdenv.isDarwin then ''
    mkdir -p $out/Applications
    cp -r ${unwrapped}/bin/nvim-qt.app $out/Applications

    chmod -R a+w $out/Applications/nvim-qt.app/Contents/MacOS
    wrapProgram $out/Applications/nvim-qt.app/Contents/MacOS/nvim-qt \
      --prefix PATH : ${neovim}/bin
  '' else ''
    makeWrapper ${unwrapped}/bin/nvim-qt $out/bin/nvim-qt \
      --prefix PATH : ${neovim}/bin

    # link .desktop file
    mkdir -p $out/share/pixmaps
    ln -s ${unwrapped}/share/applications $out/share/applications
    ln -s ${unwrapped}/share/pixmaps/nvim-qt.png $out/share/pixmaps/nvim-qt.png
  '';

  preferLocalBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  passthru = {
    inherit unwrapped;
  };

  inherit (unwrapped) meta;
}
