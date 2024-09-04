{
  stdenv,
  lib,
  fetchurl,
  unzip,
}:

let
  system = stdenv.system;
  binaries = {
    "x86_64-linux" = {
      url = "https://github.com/vadimcn/codelldb/releases/download/v1.10.0/codelldb-x86_64-linux.vsix";
      sha256 = "1jhjs2na8cjhd4yqib1vij33094sgf6lsxg9i13f2x0rh4czyayi";
    };
    "aarch64-linux" = {
      url = "https://github.com/vadimcn/codelldb/releases/download/v1.10.0/codelldb-aarch64-linux.vsix";
      sha256 = "01kxnbj9kq6sczcqp31g6xmx4l5dm4pawyqba8vlax9lg1hzd08a";
    };
    "arm-linux" = {
      url = "https://github.com/vadimcn/codelldb/releases/download/v1.10.0/codelldb-arm-linux.vsix";
      sha256 = "1jb8mx5l06zg418qnw9v53yn4ni4yhkcg3yglfdrqdflagkmxz2b";
    };
    "x86_64-darwin" = {
      url = "https://github.com/vadimcn/codelldb/releases/download/v1.10.0/codelldb-x86_64-darwin.vsix";
      sha256 = "1kzm0hrg6ji2wjxhnsj45g49dq5kll8vb760131k8154f1b0vcci";
    };
    "aarch64-darwin" = {
      url = "https://github.com/vadimcn/codelldb/releases/download/v1.10.0/codelldb-aarch64-darwin.vsix";
      sha256 = "0hbs2rr4r8zlii3srbc9xbmn5wm3p88cdsx85xp2vibbf9d7kc2a";
    };
  };
  binary = (
    binaries.${stdenv.system} or {
      url = "";
      sha256 = "";
    }
  );
in
stdenv.mkDerivation {
  pname = "codelldb";
  version = "1.10.0";

  nativeBuildInputs = [ unzip ];

  src = fetchurl {
    inherit (binary) url sha256;
  };

  unpackPhase = ''
    mkdir -p $out/bin
    unzip $src -d $out
  '';

  installPhase = ''
    ln -s $out/extension/adapter/codelldb $out/bin/codelldb
    chmod +x $out/extension/adapter/codelldb
    chmod +x $out/bin/codelldb
  '';

  meta = {
    description = "CodeLLDB executable, solely for use with nvim-dap plugin of neovim";
    homepage = "https://github.com/vadimcn/vscode-lldb";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
