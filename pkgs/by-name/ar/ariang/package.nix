{
  lib,
  fetchFromGitHub,
  nodejs_22,
  buildNpmPackage,
  copyDesktopItems,
  imagemagick,
  xdg-utils,
  makeDesktopItem,
}:

buildNpmPackage rec {
  pname = "ariang";
  version = "1.3.14";

  src = fetchFromGitHub {
    owner = "mayswind";
    repo = "AriaNg";
    tag = version;
    hash = "sha256-wPFZGNqVveDj9Dh0QSxyy93K7G91CACD4RzmgjaRxjI=";
  };

  nodejs = nodejs_22;

  npmDepsHash = "sha256-D+yqIDeJki0h6bT8eia8W8Xbokjgl4nlBXLApfhMwVc=";

  makeCacheWritable = true;

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r dist $out/share/${pname}

    for size in 16 24 36 48 72; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
      magick $out/share/${pname}/tileicon.png -resize ''${size}x''${size} \
        $out/share/icons/hicolor/''${size}x''${size}/apps/${pname}.png
    done

    mkdir -p $out/bin
    makeWrapper ${xdg-utils}/bin/xdg-open $out/bin/${pname} \
      --add-flags "file://$out/share/${pname}/index.html"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "AriaNg";
      genericName = meta.description;
      comment = meta.description;
      exec = pname;
      icon = pname;
      terminal = false;
      type = "Application";
      categories = [
        "Network"
        "WebBrowser"
      ];
    })
  ];

  meta = {
    description = "Modern web frontend making aria2 easier to use";
    homepage = "http://ariang.mayswind.net/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stunkymonkey ];
    platforms = lib.platforms.unix;
  };
}
