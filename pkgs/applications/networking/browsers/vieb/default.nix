{ mkYarnPackage, fetchFromGitHub, electron, makeWrapper, makeDesktopItem, lib, p7zip }:

mkYarnPackage rec {
  pname = "vieb";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "Jelmerro";
    repo = pname;
    rev = version;
    sha256 = "sha256-FuaN9iUxR5Y6SnNmuegmNJXn1BYKgcobquTL3thuByM=";
  };

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;
  yarnFlags = [ "--production" "--offline" ];

  nativeBuildInputs = [ makeWrapper ];

  desktopItem = makeDesktopItem {
    name = "vieb";
    exec = "vieb %U";
    icon = "vieb";
    desktopName = "Web Browser";
    genericName = "Web Browser";
    categories = [ "Network" "WebBrowser" ];
    mimeTypes = [
      "text/html"
      "application/xhtml+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
  };

  postInstall = ''
    unlink $out/libexec/vieb/deps/vieb/node_modules
    ln -s $out/libexec/vieb/node_modules $out/libexec/vieb/deps/vieb/node_modules

    find $out/libexec/vieb/node_modules/7zip-bin -name 7za -exec ln -s -f ${p7zip}/bin/7za {} ';'

    install -Dm0644 {${desktopItem},$out}/share/applications/vieb.desktop

    pushd $out/libexec/vieb/node_modules/vieb/app/img/icons
    for file in *.png; do
      install -Dm0644 $file $out/share/icons/hicolor/''${file//.png}/apps/vieb.png
    done
    popd

    makeWrapper ${electron}/bin/electron $out/bin/vieb \
      --add-flags $out/libexec/vieb/node_modules/vieb/app
  '';

  distPhase = ":"; # disable useless $out/tarballs directory

  meta = with lib; {
    homepage = "https://vieb.dev/";
    changelog = "https://github.com/Jelmerro/Vieb/releases/tag/${version}";
    description = "Vim Inspired Electron Browser";
    maintainers = with maintainers; [ gebner fortuneteller2k ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
}
