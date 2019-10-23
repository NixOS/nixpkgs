{ stdenv, callPackage, fetchurl }:

let
  inherit (stdenv.hostPlatform) system;

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin";
  }.${system};

  archive_fmt = if system == "x86_64-darwin" then "zip" else "tar.gz";

  sha256 = {
    x86_64-linux = "013jhmc29angqh9qb8jj0jqk4whqb59id61njm8gwz977sdgpf9l";
    x86_64-darwin = "09jfii132cib1kn3bghwchdlvi4cfjqz5hvw6j5gr53h7j35k37j";
  }.${system};

  sourceRoot = {
    x86_64-linux = ".";
    x86_64-darwin = "";
  }.${system};
in
  callPackage ./generic.nix rec {
    inherit sourceRoot;

    version = "1.39.2";
    pname = "vscodium";

    executableName = "codium";
    longName = "VSCodium";
    shortName = "Codium";

    src = fetchurl {
      url = "https://github.com/VSCodium/vscodium/releases/download/${version}/VSCodium-${plat}-${version}.${archive_fmt}";
      inherit sha256;
    };

    meta = with stdenv.lib; {
      description = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and macOS (VS Code without MS branding/telemetry/licensing)
      '';
      longDescription = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and macOS. It includes support for debugging, embedded Git
        control, syntax highlighting, intelligent code completion, snippets,
        and code refactoring. It is also customizable, so users can change the
        editor's theme, keyboard shortcuts, and preferences
      '';
      homepage = https://github.com/VSCodium/vscodium;
      downloadPage = https://github.com/VSCodium/vscodium/releases;
      license = licenses.mit;
      maintainers = with maintainers; [];
      platforms = [ "x86_64-linux" "x86_64-darwin" ];
    };
  }
