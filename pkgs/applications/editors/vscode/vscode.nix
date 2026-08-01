{
  lib,
  stdenv,
  stdenvNoCC,
  buildVscode,
  fetchurl,
  nixosTests,
  srcOnly,
  isInsiders ? false,
  # sourceExecutableName is the name of the binary in the source archive over
  # which we have no control and it is needed to run the insider version as
  # documented in https://wiki.nixos.org/wiki/Visual_Studio_Code#Insiders_Build
  # On MacOS the insider binary is still called code instead of code-insiders as
  # of 2023-08-06.
  sourceExecutableName ?
    "code" + lib.optionalString (isInsiders && stdenv.hostPlatform.isLinux) "-insiders",
  commandLineArgs ? "",
  useVSCodeRipgrep ? stdenv.hostPlatform.isDarwin,
}:
let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat =
    {
      x86_64-linux = "linux-x64";
      aarch64-linux = "linux-arm64";
      aarch64-darwin = "darwin-arm64";
      armv7l-linux = "linux-armhf";
    }
    .${system} or throwSystem;

  archive_fmt = if stdenv.hostPlatform.isDarwin then "zip" else "tar.gz";

  hash =
    {
      x86_64-linux = "sha256-fWrT06eKxFUcFGMfeNfgPIUoKrUFw86LG8BOAfr+iOo=";
      aarch64-linux = "sha256-CzQScd1qm4YzqXMkeWqPWCKKWtwmKQ5AsokPy/lmowA=";
      aarch64-darwin = "sha256-bhbMscqsOU2ux4i2XShdMKgJPN8tuWVSxTzJ0CUvJNM=";
      armv7l-linux = "sha256-Q84Iac2PEr9pfTtUZPgnrDpdWxl/QCf6FTquw0MJL5I=";
    }
    .${system} or throwSystem;

  # Please backport all compatible updates to the stable release.
  # This is important for the extension ecosystem.
  version = "1.130.0";

  # The update server (update.code.visualstudio.com) expects the version path
  # segment in X.Y.Z form, so we normalize X.Y to X.Y.0 (e.g. "1.110" → "1.110.0").
  # Upstream GitHub release tags may use X.Y, which is why this normalization is needed.
  downloadVersion = lib.versions.pad 3 version;

  # This is used for VS Code - Remote SSH test
  rev = "1b6a188127eeaf9194f945eb6eb89a657e93c54c";
in
buildVscode {
  pname = "vscode" + lib.optionalString isInsiders "-insiders";

  executableName = "code" + lib.optionalString isInsiders "-insiders";
  longName = "Visual Studio Code" + lib.optionalString isInsiders " - Insiders";
  shortName = "Code" + lib.optionalString isInsiders " - Insiders";
  inherit
    version
    rev
    commandLineArgs
    useVSCodeRipgrep
    sourceExecutableName
    ;

  src = fetchurl {
    name = "VSCode_${downloadVersion}_${plat}.${archive_fmt}";
    url = "https://update.code.visualstudio.com/${downloadVersion}/${plat}/stable";
    inherit hash;
  };

  # We don't test vscode on CI, instead we test vscodium
  tests = { };

  sourceRoot = "";

  # As tests run without networking, we need to download this for the Remote SSH server
  vscodeServer = srcOnly {
    name = "vscode-server-${rev}.tar.gz";
    src = fetchurl {
      name = "vscode-server-${rev}.tar.gz";
      url = "https://update.code.visualstudio.com/commit:${rev}/server-linux-x64/stable";
      hash = "sha256-ogtXQGE9/8xQYvN/juDglu6wkHJzYyL8wetF8sWnqd8=";
    };
    stdenv = stdenvNoCC;
  };

  tests = { inherit (nixosTests) vscode-remote-ssh; };

  updateScript = ./update-vscode.sh;

  # Editing the `code` binary within the app bundle causes the bundle's signature
  # to be invalidated, which prevents launching starting with macOS Ventura, because VS Code is notarized.
  # See https://eclecticlight.co/2022/06/17/app-security-changes-coming-in-ventura/ for more information.
  dontFixup = stdenv.hostPlatform.isDarwin;

  hasVsceSign = true;

  meta = {
    description = "Code editor developed by Microsoft";
    mainProgram = "code";
    longDescription = ''
      Code editor developed by Microsoft. It includes support for debugging,
      embedded Git control, syntax highlighting, intelligent code completion,
      snippets, and code refactoring. It is also customizable, so users can
      change the editor's theme, keyboard shortcuts, and preferences
    '';
    homepage = "https://code.visualstudio.com/";
    downloadPage = "https://code.visualstudio.com/Updates";
    changelog = "https://code.visualstudio.com/updates/v${
      lib.replaceString "." "_" (lib.versions.majorMinor version)
    }";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      eadwu
      bobby285271
      johnrtitor
      jefflabonte
      wetrustinprize
      oenu
      yuannan
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
      "aarch64-linux"
      "armv7l-linux"
    ];
  };
}
