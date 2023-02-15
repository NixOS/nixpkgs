{ mkYarnPackage, fetchFromGitHub, electron, makeWrapper, makeDesktopItem, lib }:

let
  srcInfo = builtins.fromJSON (builtins.readFile ./pin.json);
in
mkYarnPackage rec {
  pname = "vieb";
  inherit (srcInfo) version;

  src = fetchFromGitHub {
    owner = "Jelmerro";
    repo = pname;
    rev = version;
    inherit (srcInfo) sha256;
  };

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;
  yarnFlags = [ "--production" ];

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

    install -Dm0644 {${desktopItem},$out}/share/applications/vieb.desktop

    pushd $out/libexec/vieb/node_modules/vieb/app/img/icons
    for file in *.png; do
      install -Dm0644 $file $out/share/icons/hicolor/''${file//.png}/apps/vieb.png
    done
    popd

    makeWrapper ${electron}/bin/electron $out/bin/vieb \
      --add-flags $out/libexec/vieb/node_modules/vieb/app \
      --set npm_package_version ${version}
  '';

  distPhase = ":"; # disable useless $out/tarballs directory

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://vieb.dev/";
    changelog = "https://github.com/Jelmerro/Vieb/releases/tag/${version}";
    description = "Vim Inspired Electron Browser";
    maintainers = with maintainers; [ gebner fortuneteller2k tejing ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
}
