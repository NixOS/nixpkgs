{ stdenv, lib, callPackage, fetchurl, isInsiders ? false }:

let
  inherit (stdenv.hostPlatform) system;

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin";
    aarch64-linux = "linux-arm64";
    armv7l-linux = "linux-armhf";
  }.${system};

  archive_fmt = if system == "x86_64-darwin" then "zip" else "tar.gz";

  sha256 = {
    x86_64-linux = "0fpa3b807hy3wrb98h5s0p6ljya279bikv2qwq30nvr0f4zn48bk";
    x86_64-darwin = "0bw7pdzn0a0zr7x8fpwck7v73dq5vh71ja00z11mhjrkjnvmmd9k";
    aarch64-linux = "04wrqcmyamhwiwcyay1z0q0dvf6g7k3pcs93x7hahy16l65w7s2c";
    armv7l-linux = "1hkc9i4z021jwjn275w790bppfvi63g0cnwvkssqdh1c94939rhv";
  }.${system};
in
  callPackage ./generic.nix rec {
    # The update script doesn't correctly change the hash for darwin, so please:
    # nixpkgs-update: no auto update

    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.54.3";
    pname = "vscode";

    executableName = "code" + lib.optionalString isInsiders "-insiders";
    longName = "Visual Studio Code" + lib.optionalString isInsiders " - Insiders";
    shortName = "Code" + lib.optionalString isInsiders " - Insiders";

    src = fetchurl {
      name = "VSCode_${version}_${plat}.${archive_fmt}";
      url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
      inherit sha256;
    };

    sourceRoot = "";

    meta = with lib; {
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
      homepage = "https://code.visualstudio.com/";
      downloadPage = "https://code.visualstudio.com/Updates";
      license = licenses.unfree;
      maintainers = with maintainers; [ eadwu synthetica ];
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "armv7l-linux" ];
    };
  }
