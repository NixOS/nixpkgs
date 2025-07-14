{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  mono,
  gtk2,
  curl,
  imagemagick,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "ckan";
  version = "1.36.0";

  src = fetchurl {
    url = "https://github.com/KSP-CKAN/CKAN/releases/download/v${version}/ckan.exe";
    hash = "sha256-Tw8s86FtBz/92uq2imFZm4n88NCCpePTpydoAoYsE3U=";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/KSP-CKAN/CKAN/450e2f960e1a3fee4ab7cf74ad56bddc5296fc7e/assets/ckan-256.png";
    hash = "sha256-BJvuOz8NWmzpYzzhveeq6rcuqXIxQqxtBIcRvobx+TY=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
    makeWrapper
  ];

  buildInputs = [ mono ];

  libraries = lib.makeLibraryPath [
    gtk2
    curl
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    for size in 16 24 48 64 96 128 256; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick -background none ${icon} -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/${pname}.png
    done
    install -m 644 -D $src $out/bin/ckan.exe
    makeWrapper ${mono}/bin/mono $out/bin/ckan \
      --add-flags $out/bin/ckan.exe \
      --set LD_LIBRARY_PATH $libraries
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ckan";
      comment = "The Comprehensive Kerbal Archive Network Client";
      desktopName = "CKAN";
      categories = [
        "Game"
        "PackageManager"
      ];
      exec = "ckan";
      icon = "ckan";
      keywords = [
        "Kerbal Space Program"
        "KSP"
        "Mod"
      ];
      extraConfig.X-GNOME-SingleWindow = "true";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Mod manager for Kerbal Space Program";
    mainProgram = "ckan";
    homepage = "https://github.com/KSP-CKAN/CKAN";
    license = licenses.mit;
    maintainers = with maintainers; [
      Baughn
      ymarkus
      nullcube
    ];
    platforms = platforms.all;
  };
}
