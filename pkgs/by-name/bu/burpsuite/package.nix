{
  lib,
  buildFHSEnv,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  jdk,
  proEdition ? false,
  unzip,
}:

let
  product =
    if proEdition then
      {
        productName = "pro";
        productDesktop = "Burp Suite Professional Edition";
        hash = "sha256-KF6VOXO3IKsysA3SBJJzL+G2yQEVpCQKL6IMYQhYFMc=";
      }
    else
      {
        productName = "community";
        productDesktop = "Burp Suite Community Edition";
        hash = "sha256-5LNzF68VhGdWttzZCkw/Ign4x6V4EhU/EHMddeSVirk=";
      };
in
buildFHSEnv rec {
  pname = "burpsuite";
  version = "2026.1.2";

  src = fetchurl {
    name = "burpsuite.jar";
    urls = [
      "https://portswigger-cdn.net/burp/releases/download?product=${product.productName}&version=${version}&type=Jar"
      "https://portswigger.net/burp/releases/download?product=${product.productName}&version=${version}&type=Jar"
      "https://web.archive.org/web/https://portswigger.net/burp/releases/download?product=${product.productName}&version=${version}&type=Jar"
    ];
    hash = product.hash;
  };

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = meta.mainProgram;
      icon = pname;
      desktopName = product.productDesktop;
      comment = meta.description;
      categories = [
        "Development"
        "Security"
        "System"
      ];
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
  ];

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
      libglvnd
      nspr
      nss
      pango
      libx11
      libxcb
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
    ];

  # install icon
  extraInstallCommands = ''
    mkdir -p "$out/share/icons/hicolor/64x64/apps"
    ${lib.getBin unzip}/bin/unzip -p "${src}" "resources/Media/icon64${product.productName}.png" > "$out/share/icons/hicolor/64x64/apps/burpsuite.png"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Integrated platform for performing security testing of web applications";
    longDescription = ''
      Burp Suite is an integrated platform for performing security testing of web applications.
      Its various tools work seamlessly together to support the entire testing process, from
      initial mapping and analysis of an application's attack surface, through to finding and
      exploiting security vulnerabilities.
    '';
    homepage = "https://portswigger.net/burp/";
    changelog =
      "https://portswigger.net/burp/releases/professional-community-"
      + lib.replaceStrings [ "." ] [ "-" ] version;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.unfree;
    platforms = jdk.meta.platforms;
    hydraPlatforms = [ ];
    maintainers = with lib.maintainers; [
      bennofs
      blackzeshi
      fab
      yechielw
    ];
    mainProgram = "burpsuite";
  };
}
