{ stdenv
, lib
, callPackage
, fetchurl
, nixosTests
, srcOnly
, isInsiders ? false
# sourceExecutableName is the name of the binary in the source archive over
# which we have no control and it is needed to run the insider version as
# documented in https://nixos.wiki/wiki/Visual_Studio_Code#Insiders_Build
# On MacOS the insider binary is still called code instead of code-insiders as
# of 2023-08-06.
, sourceExecutableName ? "code" + lib.optionalString (isInsiders && stdenv.isLinux) "-insiders"
, commandLineArgs ? ""
, useVSCodeRipgrep ? stdenv.isDarwin
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
    armv7l-linux = "linux-armhf";
  }.${system} or throwSystem;

  archive_fmt = if stdenv.isDarwin then "zip" else "tar.gz";

  sha256 = {
    x86_64-linux = "0i6zk4zkwcw5lnzhg7vvnsw17nar97bbq3iishag9cpjqs9jpq4z";
    x86_64-darwin = "1sy0ir4mhw9j5ifiv6d2928gcs8wfksxlsp312r9nsmc2h0i11g6";
    aarch64-linux = "13lsycmia9yj6s7zf441vg8c0pipxpxdrnrj7v4rhjlvixjb8f8k";
    aarch64-darwin = "1qwmwx0q05lzhsb8810kjk1lcw4wm7cr0zn7pkyjlsda0vkcc5g8";
    armv7l-linux = "1hlnd9w141phrd3mzkhgiskbcnxqb05396frrv38pns007xhj103";
  }.${system} or throwSystem;
in
  callPackage ./generic.nix rec {
    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.82.2";
    pname = "vscode" + lib.optionalString isInsiders "-insiders";

    # This is used for VS Code - Remote SSH test
    rev = "abd2f3db4bdb28f9e95536dfa84d8479f1eb312d";

    executableName = "code" + lib.optionalString isInsiders "-insiders";
    longName = "Visual Studio Code" + lib.optionalString isInsiders " - Insiders";
    shortName = "Code" + lib.optionalString isInsiders " - Insiders";
    inherit commandLineArgs useVSCodeRipgrep sourceExecutableName;

    src = fetchurl {
      name = "VSCode_${version}_${plat}.${archive_fmt}";
      url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
      inherit sha256;
    };

    # We don't test vscode on CI, instead we test vscodium
    tests = {};

    sourceRoot = "";

    # As tests run without networking, we need to download this for the Remote SSH server
    vscodeServer = srcOnly {
      name = "vscode-server-${rev}.tar.gz";
      src = fetchurl {
        name = "vscode-server-${rev}.tar.gz";
        url = "https://update.code.visualstudio.com/commit:${rev}/server-linux-x64/stable";
        sha256 = "1d1ypmasr7zj4csinb5nj531ckj7a1pgn36469fdzwn0xjrgkg16";
      };
    };

    tests = { inherit (nixosTests) vscode-remote-ssh; };

    updateScript = ./update-vscode.sh;

    # Editing the `code` binary within the app bundle causes the bundle's signature
    # to be invalidated, which prevents launching starting with macOS Ventura, because VS Code is notarized.
    # See https://eclecticlight.co/2022/06/17/app-security-changes-coming-in-ventura/ for more information.
    dontFixup = stdenv.isDarwin;

    meta = with lib; {
      description = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and macOS
      '';
      mainProgram = "code";
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
      maintainers = with maintainers; [ eadwu synthetica amaxine bobby285271 Enzime ];
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" "armv7l-linux" ];
    };
  }
