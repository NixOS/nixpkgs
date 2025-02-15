{
  lib,
  buildFHSEnv,
  fetchurl,
  jdk,
  makeDesktopItem,
  proEdition ? false,
  unzip,
}:

let
  version = "2025.1.1";

  product =
    if proEdition then
      {
        productName = "pro";
        productDesktop = "Burp Suite Professional Edition";
        hash = "sha256-17COQ9deYkzmaXBbg1arD3BQY7l3WZ9FakLXzTxgmr8=";
      }
    else
      {
        productName = "community";
        productDesktop = "Burp Suite Community Edition";
        hash = "sha256-VnDVv492suHIjDqermH79Rcz4hb3bmgazIiBvbwV3Zc=";
      };

  src = fetchurl {
    name = "burpsuite.jar";
    urls = [
      "https://portswigger-cdn.net/burp/releases/download?product=${product.productName}&version=${version}&type=Jar"
      "https://portswigger.net/burp/releases/download?product=${product.productName}&version=${version}&type=Jar"
      "https://web.archive.org/web/https://portswigger.net/burp/releases/download?product=${product.productName}&version=${version}&type=Jar"
    ];
    hash = product.hash;
  };

  pname = "burpsuite";
  description = "An integrated platform for performing security testing of web applications";
  desktopItem = makeDesktopItem {
    name = "burpsuite";
    exec = pname;
    icon = pname;
    desktopName = product.productDesktop;
    comment = description;
    categories = [
      "Development"
      "Security"
      "System"
    ];
  };

in
buildFHSEnv {
  inherit pname version;

  runScript = "${jdk}/bin/java -jar ${src}";

  targetPkgs =
    pkgs: with pkgs; [
      alsa-lib
      at-spi2-core
      cairo
      cups
      dbus
      expat
      glib
      gtk3
      gtk3-x11
      jython
      libcanberra-gtk3
      libdrm
      udev
      libxkbcommon
      libgbm
      nspr
      nss
      pango
      xorg.libX11
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
    ];

  extraInstallCommands = ''
    mkdir -p "$out/share/pixmaps"
    ${lib.getBin unzip}/bin/unzip -p ${src} resources/Media/icon64${product.productName}.png > "$out/share/pixmaps/burpsuite.png"
    cp -r ${desktopItem}/share/applications $out/share
  '';

  meta = with lib; {
    inherit description;
    longDescription = ''
      Burp Suite is an integrated platform for performing security testing of web applications.
      Its various tools work seamlessly together to support the entire testing process, from
      initial mapping and analysis of an application's attack surface, through to finding and
      exploiting security vulnerabilities.
    '';
    homepage = "https://portswigger.net/burp/";
    changelog =
      "https://portswigger.net/burp/releases/professional-community-"
      + replaceStrings [ "." ] [ "-" ] version;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfree;
    platforms = jdk.meta.platforms;
    hydraPlatforms = [ ];
    maintainers = with maintainers; [
      bennofs
      fab
    ];
    mainProgram = "burpsuite";
  };
}
