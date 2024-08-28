{ pkgs ? import <nixpkgs> {} }:

let
  stdenv = pkgs.stdenv;
  lib = pkgs.lib;
  binary =
    with stdenv;
    if stdenv.isLinux then
      if stdenv.system == "x86_64-linux" then
        {
          url = "https://github.com/vadimcn/codelldb/releases/download/v1.10.0/codelldb-x86_64-linux.vsix";
          sha256 = "1jhjs2na8cjhd4yqib1vij33094sgf6lsxg9i13f2x0rh4czyayi";
        }
      else if stdenv.system == "aarch64-linux" then
        {
          url = "https://github.com/vadimcn/codelldb/releases/download/v1.10.0/codelldb-aarch64-linux.vsix";
          sha256 = "01kxnbj9kq6sczcqp31g6xmx4l5dm4pawyqba8vlax9lg1hzd08a";
        }
      else if stdenv.system == "arm-linux" then
        {
          url = "https://github.com/vadimcn/codelldb/releases/download/v1.10.0/codelldb-arm-linux.vsix";
          sha256 = "1jb8mx5l06zg418qnw9v53yn4ni4yhkcg3yglfdrqdflagkmxz2b";
        }
      else
        {
          url = "";
          sha256 = "";
        }
    else if stdenv.isDarwin then
      if stdenv.system == "x86_64-darwin" then
        {
          url = "https://github.com/vadimcn/codelldb/releases/download/v1.10.0/codelldb-x86_64-darwin.vsix";
          sha256 = "1kzm0hrg6ji2wjxhnsj45g49dq5kll8vb760131k8154f1b0vcci";
        }
      else if stdenv.system == "aarch64-darwin" then
        {
          url = "https://github.com/vadimcn/codelldb/releases/download/v1.10.0/codelldb-aarch64-darwin.vsix";
          sha256 = "0hbs2rr4r8zlii3srbc9xbmn5wm3p88cdsx85xp2vibbf9d7kc2a";
        }
      else
        {
          url = "";
          sha256 = "";
        }
    else
      {
        url = "";
        sha256 = "";
      };
in
pkgs.stdenv.mkDerivation {
  pname = "codelldb";
  version = "1.10.0";

  nativeBuildInputs = [ pkgs.unzip ];

  src = pkgs.fetchurl {
    url = binary.url;
    sha256 = binary.sha256;
  };

  unpackPhase = ''
    mkdir -p $out/bin
    unzip $src -d $out/bin
  '';

  installPhase = ''
    ln -s $out/bin/extension/adapter/codelldb $out/bin/codelldb
    chmod +x $out/bin/extension/adapter/codelldb
    chmod +x $out/bin/codelldb
  '';

  meta = {
    description = "CodeLLDB executable, solely for use with nvim-dap plugin of neovim";
    homepage = "https://github.com/vadimcn/vscode-lldb";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
