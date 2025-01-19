{
  lib,
  stdenv,
  callPackage,
  fetchurl,
  nixosTests,
  commandLineArgs ? "",
  useVSCodeRipgrep ? stdenv.hostPlatform.isDarwin,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat =
    {
      x86_64-linux = "linux-x64";
      x86_64-darwin = "darwin-x64";
      aarch64-linux = "linux-arm64";
      aarch64-darwin = "darwin-arm64";
      armv7l-linux = "linux-armhf";
    }
    .${system} or throwSystem;

  archive_fmt = if stdenv.hostPlatform.isDarwin then "zip" else "tar.gz";

  sha256 =
    {
      x86_64-linux = "1p2y9vh286f85nrj5262kfgx6v4z0466f49701pqh6hflqhlwz8w";
      x86_64-darwin = "03308a6asi4hb1v66n212hz2rrx5giw5j03n2y3j9wnrs4mys8l2";
      aarch64-linux = "156i2yxccrbsn5vqlzbgn99rf7qwj41wgqsh52qar6mha13s5rl5";
      aarch64-darwin = "0jn3m0rmy9nv4gvd0ni0jq5dyqqm95i0b2qq6lgmzsdi7q2z36g7";
      armv7l-linux = "0xpiqd8laswcrhpkw0p60j3hcj29kwsgr2pychsrjasgb3n7cml6";
    }
    .${system} or throwSystem;

  sourceRoot = lib.optionalString (!stdenv.hostPlatform.isDarwin) ".";
in
callPackage ../../../applications/editors/vscode/generic.nix rec {
  inherit sourceRoot commandLineArgs useVSCodeRipgrep;

  # Please backport all compatible updates to the stable release.
  # This is important for the extension ecosystem.
  version = "1.96.2.25010";
  pname = "vscodium";

  executableName = "aide";
  longName = "aide.dev";
  shortName = "aide";

  src = fetchurl {
    url = "https://github.com/codestoryai/binaries/releases/download/${version}/Aide-${plat}-${version}.${archive_fmt}";
    inherit sha256;
  };

  updateScript = ./update-aide.sh;

  meta = with lib; {
    description = ''
      The open-source AI-native IDE
    '';
    homepage = "https://aide.dev/";
    downloadPage = "https://github.com/codestoryai/binaries";
    license = licenses.agpl3Only;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [
      ericthemagician
    ];
    mainProgram = "aide";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
      "armv7l-linux"
    ];
  };
}
