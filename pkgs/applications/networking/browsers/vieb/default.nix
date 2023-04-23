{ stdenv, buildNpmPackage, fetchFromGitHub, electron, makeWrapper, python3, makeDesktopItem, nix-update-script, lib }:

buildNpmPackage rec {
  pname = "vieb";
  version = "9.7.0";

  src = fetchFromGitHub {
    owner = "Jelmerro";
    repo = pname;
    rev = version;
    hash = "sha256-uo5V5RRDSR+f9+AqojikrlybmtcWTmB7TPXEvLG9n4E=";
  };

  postPatch = ''
    sed -i '/"electron"/d' package.json
  '';

  npmDepsHash = "sha256-RUpeqbb8bnSQ6sCYH8O9mL3Rpb+ZlcPi7fq6LlbkSic=";
  dontNpmBuild = true;

  nativeBuildInputs = [ makeWrapper ] ++ lib.optional stdenv.isAarch64 python3;

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
    install -Dm0644 {${desktopItem},$out}/share/applications/vieb.desktop

    pushd $out/lib/node_modules/vieb/app/img/icons
    for file in *.png; do
      install -Dm0644 $file $out/share/icons/hicolor/''${file//.png}/apps/vieb.png
    done
    popd

    makeWrapper ${electron}/bin/electron $out/bin/vieb \
      --add-flags $out/lib/node_modules/vieb/app \
      --set npm_package_version ${version}
  '';

  distPhase = ":"; # disable useless $out/tarballs directory

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    homepage = "https://vieb.dev/";
    changelog = "https://github.com/Jelmerro/Vieb/releases/tag/${version}";
    description = "Vim Inspired Electron Browser";
    maintainers = with maintainers; [ gebner fortuneteller2k tejing ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
}
