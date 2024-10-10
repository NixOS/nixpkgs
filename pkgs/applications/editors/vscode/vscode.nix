{ stdenv
, lib
, callPackage
, fetchurl
, nixosTests
, srcOnly
, isInsiders ? false
# sourceExecutableName is the name of the binary in the source archive over
# which we have no control and it is needed to run the insider version as
# documented in https://wiki.nixos.org/wiki/Visual_Studio_Code#Insiders_Build
# On MacOS the insider binary is still called code instead of code-insiders as
# of 2023-08-06.
, sourceExecutableName ? "code" + lib.optionalString (isInsiders && stdenv.hostPlatform.isLinux) "-insiders"
, commandLineArgs ? ""
, useVSCodeRipgrep ? stdenv.hostPlatform.isDarwin
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

  archive_fmt = if stdenv.hostPlatform.isDarwin then "zip" else "tar.gz";

  sha256 = {
    x86_64-linux = "11d9qqfb5kh5zsc7xd6h5xsywacir5z08l2snj0cz2cb0nji9xhj";
    x86_64-darwin = "0rbwvvakh1b5iqca49hcmqlfq4g0j067rrphrh0yx7wdyr6kmwg2";
    aarch64-linux = "0vrvcy1p5lrdy2lww42w32vr79075vpkwj4q8wfqzd7x72vmhfci";
    aarch64-darwin = "03wccm854v9va50x91kp00a16r483zpndayhlwy1fm4n0wdy6iw8";
    armv7l-linux = "0b9r78mz5djvv6n82isn2jqb4bwa41hqyxxc9arhrpvpj5w65rla";
  }.${system} or throwSystem;
in
  callPackage ./generic.nix rec {
    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.94.1";
    pname = "vscode" + lib.optionalString isInsiders "-insiders";

    # This is used for VS Code - Remote SSH test
    rev = "e10f2369d0d9614a452462f2e01cdc4aa9486296";

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
        sha256 = "094klvp32475f6rsapxkhgsm8cmjmpq4qp3lx2b1vgf3xzl7j9nw";
      };
    };

    tests = { inherit (nixosTests) vscode-remote-ssh; };

    updateScript = ./update-vscode.sh;

    # Editing the `code` binary within the app bundle causes the bundle's signature
    # to be invalidated, which prevents launching starting with macOS Ventura, because VS Code is notarized.
    # See https://eclecticlight.co/2022/06/17/app-security-changes-coming-in-ventura/ for more information.
    dontFixup = stdenv.hostPlatform.isDarwin;

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
      maintainers = with maintainers; [ eadwu synthetica bobby285271 johnrtitor ];
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" "armv7l-linux" ];
    };
  }
