{ stdenv, lib, callPackage, fetchurl, isInsiders ? false }:

let
  inherit (stdenv.hostPlatform) system;

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin";
  }.${system};

  archive_fmt = if system == "x86_64-darwin" then "zip" else "tar.gz";

  sha256 = {
    x86_64-linux = "00b6q3rvf9v993i8d1vh9ckb86s655mz6kqkw0lxg8xmhpm568ra";
    x86_64-darwin = "1r4qbjbypdqx9qmycykgkrg8anckicmdmawwwsszgkdd0zd5idgg";
  }.${system};
in
  callPackage ./generic.nix rec {
    # The update script doesn't correctly change the hash for darwin, so please:
    # nixpkgs-update: no auto update

    version = "1.41.1";
    pname = "vscode";

    executableName = "code" + lib.optionalString isInsiders "-insiders";
    longName = "Visual Studio Code" + lib.optionalString isInsiders " - Insiders";
    shortName = "Code" + lib.optionalString isInsiders " - Insiders";

    src = fetchurl {
      name = "VSCode_${version}_${plat}.${archive_fmt}";
      url = "https://vscode-update.azurewebsites.net/${version}/${plat}/stable";
      inherit sha256;
    };

    sourceRoot = "";

    meta = with stdenv.lib; {
      description = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and macOS
      '';
      longDescription = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and macOS. It includes support for debugging, embedded Git
        control, syntax highlighting, intelligent code completion, snippets,
        and code refactoring. It is also customizable, so users can change the
        editor's theme, keyboard shortcuts, and preferences
      '';
      homepage = https://code.visualstudio.com/;
      downloadPage = https://code.visualstudio.com/Updates;
      license = licenses.unfree;
      maintainers = with maintainers; [ eadwu synthetica ];
      platforms = [ "x86_64-linux" "x86_64-darwin" ];
    };
  }
