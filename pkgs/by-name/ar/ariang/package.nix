{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  copyDesktopItems,
  imagemagick,
  xdg-utils,
  makeDesktopItem,
}:

buildNpmPackage rec {
  pname = "ariang";
  version = "1.3.15";

  src = fetchFromGitHub {
    owner = "mayswind";
    repo = "AriaNg";
    tag = version;
    hash = "sha256-YgT5lUwer5tkP2gHYkTY1LhPJN51nZjSztp7oq0mgXw=";
  };

  # The v1 lockfile stores the git dependency's URL in place of its version,
  # which npm >= 11 cannot verify against package.json during `npm ci`.
  # Fetch the same commit as a plain tarball, so the lockfile can record
  # its version and integrity.
  postPatch =
    let
      gitUrl = "git+https://github.com/mayswind/angular-input-dropdown.git#68670e39816698b3eb98c0e740a0efe77d5fbdd1";
      tarballUrl = "https://codeload.github.com/mayswind/angular-input-dropdown/tar.gz/68670e39816698b3eb98c0e740a0efe77d5fbdd1";
    in
    ''
      substituteInPlace package.json \
        --replace-fail '"${gitUrl}"' '"${tarballUrl}"'
      substituteInPlace package-lock.json \
        --replace-fail '"version": "${gitUrl}"' '"version": "1.1.2", "resolved": "${tarballUrl}", "integrity": "sha512-RPcedTqQyLf6yrbGVolVyUG3aldu0V3BYx0FLz1fDy0li3sntGiKPKNAKex6IjMdhBGmntkItUr3xg96cGVImg=="' \
        --replace-fail '"from": "${gitUrl}"' '"from": "${tarballUrl}"'
    '';

  npmDepsHash = "sha256-pobzDuc7LorgX35rgs9QhkNsMlYqWREt4TOB9ujHG40=";

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
