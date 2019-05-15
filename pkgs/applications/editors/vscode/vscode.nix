{ stdenv, lib, callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {

  # How can I get plat and archive_fmt from generic.nix?
  #inherit plat archive_fmt;

  plat = {
    "i686-linux" = "linux-ia32";
    "x86_64-linux" = "linux-x64";
    "x86_64-darwin" = "darwin";
  }.${system};

  archive_fmt = if system == "x86_64-darwin" then "zip" else "tar.gz";

  inherit (stdenv.hostPlatform) system;

  version = "1.33.1";

  # Same here, I have trouble getting isInsiders, and I don't understand its purpose since it is not used anywhere else in the repo
  #executableName = "code" + lib.optionalString isInsiders "-insiders";
  #longName = "Visual Studio Code" + lib.optionalString isInsiders " - Insiders";
  #shortName = "Code" + lib.optionalString isInsiders " - Insiders";

  executableName = "code";
  longName = "Visual Studio Code";
  shortName = "Code";

  name = "vscode-${version}";

  sha256 = {
    "i686-linux" = "0n2k134yx0zirddi5xig4zihn73s8xiga11pwk90f01wp1i0hygg";
    "x86_64-linux" = "0ljijcqfyrfck5imldis3hx9d9iacnspgnm58kvlziam8y0imwzv";
    "x86_64-darwin" = "00fg106rggsbng90k1jjp1c6nmnwni5s0fgmbz6k45shfa3iqamc";
  }.${system};

  src = fetchurl {
    name = "VSCode_${version}_${plat}.${archive_fmt}";
    url = "https://vscode-update.azurewebsites.net/${version}/${plat}/stable";
    inherit sha256;
  };

  # I don't know how to split meta between the files. "platforms" should be shared
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
})
