{ lib
, stdenvNoCC
, rustPlatform
, fetchFromGitHub
, buildNpmPackage
, perl
, pkg-config
, glib
, webkitgtk
, libappindicator-gtk3
, libayatana-appindicator
, cairo
, openssl
}:

let
  version = "4.7.8";
  geph-meta = with lib; {
    description = "A modular Internet censorship circumvention system designed specifically to deal with national filtering.";
    homepage = "https://geph.io";
    platforms = platforms.linux;
    maintainers = with maintainers; [ penalty1083 ];
  };
in
{
  cli = rustPlatform.buildRustPackage rec {
    pname = "geph4-client";
    inherit version;

    src = fetchFromGitHub {
      owner = "geph-official";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-DVGbLyFgraQMSIUAqDehF8DqbnvcaeWbuLVgiSQY3KE=";
    };

    cargoHash = "sha256-uBq6rjUnKEscwhu60HEZffLvuXcArz+AiR52org+qKw=";

    nativeBuildInputs = [ perl ];

    meta = geph-meta // {
      license = with lib.licenses; [ gpl3Only ];
    };
  };

  gui = stdenvNoCC.mkDerivation rec {
    pname = "geph-gui";
    inherit version;

    src = fetchFromGitHub {
      owner = "geph-official";
      repo = "gephgui-pkg";
      rev = "85a55bfc2f4314d9c49608f252080696b1f8e2a9";
      hash = "sha256-id/sfaQsF480kUXg//O5rBIciuuhDuXY19FQe1E3OQs=";
      fetchSubmodules = true;
    };

    gephgui = buildNpmPackage {
      pname = "gephgui";
      inherit version src;

      sourceRoot = "source/gephgui-wry/gephgui";

      postPatch = "ln -s ${./package-lock.json} ./package-lock.json";

      npmDepsHash = "sha256-5y6zpMF4M56DiWVhMvjJGsYpVdlJSoWoWyPgLc7hJoo=";

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        mv dist $out

        runHook postInstall
      '';
    };

    gephgui-wry = rustPlatform.buildRustPackage rec {
      pname = "gephgui-wry";
      inherit version src;

      sourceRoot = "source/gephgui-wry";

      cargoHash = "sha256-lidlUUfHXKPUlICdaVv/SFlyyWsZ7cYHyTJ3kkMn3L4=";

      nativeBuildInputs = [ pkg-config ];

      buildInputs = [
        glib
        webkitgtk
        libappindicator-gtk3
        libayatana-appindicator
        cairo
        openssl
      ];

      preBuild = ''
        ln -s ${gephgui}/dist ./gephgui
      '';
    };

    dontBuild = true;

    installPhase = ''
      install -Dt $out/bin ${gephgui-wry}/bin/gephgui-wry
      install -d $out/share/icons/hicolor
      for i in '16' '32' '64' '128' '256'
      do
        name=''${i}x''${i}
        dir=$out/share/icons/hicolor
        mkdir -p $dir
        mv flatpak/icons/$name $dir
      done
      install -Dt $out/share/applications flatpak/icons/io.geph.GephGui.desktop
      sed -i -e '/StartupWMClass/s/=.*/=gephgui-wry/' $out/share/applications/io.geph.GephGui.desktop
    '';

    meta = geph-meta // {
      license = with lib.licenses; [ unfree ];
    };
  };
}
