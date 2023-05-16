{ stdenv, buildNpmPackage, fetchFromGitHub, electron, makeWrapper, python3, makeDesktopItem, nix-update-script, lib }:

buildNpmPackage rec {
  pname = "vieb";
<<<<<<< HEAD
  version = "10.2.0";
=======
  version = "9.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Jelmerro";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-eI+doYI5kssuVLNLlAj67CRvBuWQ+TRm0RKXPcW+S8c=";
=======
    hash = "sha256-1G3hhqWMClxdwt3aOmnAbEV+n2ui5X6Cgf30391OVi0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    sed -i '/"electron"/d' package.json
  '';

<<<<<<< HEAD
  npmDepsHash = "sha256-Emiw5ZlHh4+YqtW+T3iQW/ldr1Exx/66vsQteCijObQ=";
=======
  npmDepsHash = "sha256-t8fKbh9M63CCkxwlXj3zGvP8y5uLMqbyNd8BimBhIBc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
