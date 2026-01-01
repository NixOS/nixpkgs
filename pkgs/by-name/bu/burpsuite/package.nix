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
<<<<<<< HEAD
  version = "2025.12";
=======
  version = "2025.11.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  product =
    if proEdition then
      {
        productName = "pro";
        productDesktop = "Burp Suite Professional Edition";
<<<<<<< HEAD
        hash = "sha256-6firazY0uyDBjdw8Qvs48xVXwy3MfCULtitb1gvGHQM=";
=======
        hash = "sha256-uI3xjh1z4g9+ZjjbXi4CLoKT+9y2rbu8u8rqD9+aOFA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      }
    else
      {
        productName = "community";
        productDesktop = "Burp Suite Community Edition";
<<<<<<< HEAD
        hash = "sha256-hvhS6JKISPeDp0L7ElI/BojitUp93TvuPgO4zKBJjnI=";
=======
        hash = "sha256-XZgG6BfA2O4gZfy+dYuc5yzpe+sHPjthzvexBb4YWcQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
  description = "Integrated platform for performing security testing of web applications";
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

  passthru.updateScript = ./update.sh;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
      + lib.replaceStrings [ "." ] [ "-" ] version;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.unfree;
    platforms = jdk.meta.platforms;
    hydraPlatforms = [ ];
    maintainers = with lib.maintainers; [
=======
      + replaceStrings [ "." ] [ "-" ] version;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfree;
    platforms = jdk.meta.platforms;
    hydraPlatforms = [ ];
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      bennofs
      blackzeshi
      fab
      yechielw
    ];
    mainProgram = "burpsuite";
  };
}
