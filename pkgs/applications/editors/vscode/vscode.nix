{ stdenv, lib, callPackage, fetchurl, fetchpatch, isInsiders ? false }:

let
  inherit (stdenv.hostPlatform) system;

  plat = {
    "i686-linux" = "linux-ia32";
    "x86_64-linux" = "linux-x64";
    "x86_64-darwin" = "darwin";
  }.${system};

  archive_fmt = if system == "x86_64-darwin" then "zip" else "tar.gz";

  sha256 = {
    "i686-linux" = "1485maq7rrvi742w0zs5nnaqy2s7w4hhm0fi4n69vafncia8zyic";
    "x86_64-linux" = "082725c7yzih13d4khvwz34ijwdg6yxmsxhjmpn2pqlfsg43hxsh";
    "x86_64-darwin" = "1mvj63sbdcw227bi4idqcwqxds60g64spvdi2bxh5sk6g5q5df90";
  }.${system};
in
  callPackage ./generic.nix rec {

    version = "1.35.0";
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
      platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    };
  }
