{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  copyDesktopItems,
  imagemagick,
  xdg-utils,
  makeDesktopItem,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "ariang";
  version = "1.3.11";

  src = fetchFromGitHub {
    owner = "mayswind";
    repo = "AriaNg";
    rev = version;
    hash = "sha256-TisgE5VFOe/1LbDq43AHASMVhC85BglETYFcvsQpwMw=";
  };

  npmDepsHash = "sha256-wWy9XxwZvUo89kgxApHd3qZ2Bb4NgifQ96WRDsZvTGU=";

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern web frontend making aria2 easier to use";
    homepage = "http://ariang.mayswind.net/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stunkymonkey ];
    platforms = lib.platforms.unix;
  };
}
