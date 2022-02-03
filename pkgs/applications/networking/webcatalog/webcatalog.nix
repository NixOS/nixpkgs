{ stdenv, lib, callPackage, fetchurl }:

let
  inherit (stdenv.hostPlatform) system;

  archive_suffix = if system == "x86_64-darwin" then "-mac.zip" else ".tar.gz";

  sha256 = {
    x86_64-linux = "0yv6584y4idkl9vvmpxj5ix5brshm1vadiwf7ima84snm0fipb0n";
    x86_64-darwin = "0igndxkwkxyjc9rkf9hbj8903hvfv7ab41q0s3gw8w5qh4b8s48x";
  }.${system};
in
  callPackage ./generic.nix rec {
    pname = "webcatalog";

    executableName = "webcatalog";
    longName = "WebCatalog";
    shortName = "WebCatalog";

    src = fetchurl {
      url = "https://github.com/webcatalog/webcatalog-app/releases/download/v${version}/WebCatalog-${version}${archive_suffix}";
      inherit sha256;
    };

    sourceRoot = "";

    meta = with stdenv.lib; {
      description = ''
        Open source tool for Windows, Linux and macOS
        that turns any websites into desktop apps
      '';
      longDescription = ''
        WebCatalog is the only application store that gives you
        access to thousands of exclusive desktop apps with many
        amazing features to enhance your workflow. Even more,
        it turns any websites into desktop apps, quick and easy!
      '';
      homepage = "https://webcatalog.app/";
      downloadPage = "https://code.visualstudio.com/Updates";
      license = licenses.unfree;
      maintainers = with maintainers; [ eadwu synthetica ];
      platforms = [ "x86_64-linux" "x86_64-darwin" ];
    };
  }
