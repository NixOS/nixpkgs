{ stdenv, fetchurl, buildFHSUserEnv, makeDesktopItem, runCommand, bash, wrapGAppsHook, gsettings_desktop_schemas, gtk3, gnome3 }:

let
version = "5.0.25";
meta = with stdenv.lib; {
  homepage = https://www.zotero.org;
  description = "Collect, organize, cite, and share your research sources";
  license = licenses.agpl3;
  platforms = platforms.linux;
};

zoteroSrc = stdenv.mkDerivation rec {
  inherit version;
  name = "zotero-${version}-pkg";

  src = fetchurl {
    url = "https://download.zotero.org/client/release/${version}/Zotero-${version}_linux-x86_64.tar.bz2";
    sha256 = "1y3q5582xp4inpz137x0r9iscs1g0cjlqcfjpzl3klsq3yas688k";
  };

  buildInputs= [ wrapGAppsHook gsettings_desktop_schemas gtk3 gnome3.adwaita-icon-theme gnome3.dconf ];
  phases = [ "unpackPhase" "installPhase" "fixupPhase"];

  installPhase = ''
    mkdir -p $out/data
    cp -r * $out/data
    mkdir $out/bin
    ln -s $out/data/zotero $out/bin/zotero
  '';
};

fhsEnv = buildFHSUserEnv {
  name = "zotero-fhs-env";
  targetPkgs = pkgs: with pkgs; with xlibs; [
    gtk3 dbus_glib
    libXt nss
  ];
};

desktopItem = makeDesktopItem rec {
  name = "zotero-${version}";
  exec = "zotero -url %U";
  icon = "zotero";
  type = "Application";
  comment = meta.description;
  desktopName = "Zotero";
  genericName = "Reference Management";
  categories = "Office;Database;";
  startupNotify = "true";
};

in runCommand "zotero-${version}" { inherit meta; } ''
  mkdir -p $out/bin $out/share/applications
  cat >$out/bin/zotero <<EOF
#!${bash}/bin/bash
${fhsEnv}/bin/zotero-fhs-env ${zoteroSrc}/bin/zotero
EOF
  chmod +x $out/bin/zotero

  cp ${desktopItem}/share/applications/* $out/share/applications/

  for size in 16 32 48 256; do
    install -Dm444 ${zoteroSrc}/data/chrome/icons/default/default$size.png \
      $out/share/icons/hicolor/''${size}x''${size}/apps/zotero.png
  done
''
