{
  stdenv,
  lib,
  fetchFromGitHub,
  fpc,
  lazarus-qt6,
  qt6Packages,
  autoPatchelfHook,
  writableTmpDirAsHomeHook,
  mariadb-connector-c,
  libpq,
  sqlite,
  freetds,
  firebird,
  writers,
  copyDesktopItems,
  makeDesktopItem,
  gitUpdater,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    makeDbConnector =
      {
        package,
        library,
        path ? "lib",
      }:
      {
        inherit package library;
        path = "${lib.getLib package}/${path}";
      };

    dbConnectors = [
      (makeDbConnector {
        package = mariadb-connector-c;
        library = "libmariadb.so";
        path = "lib/mariadb";
      })
      (makeDbConnector {
        package = libpq;
        library = "libpq.so";
      })
      (makeDbConnector {
        package = sqlite;
        library = "libsqlite3.so";
      })
      (makeDbConnector {
        package = freetds;
        library = "libsybdb.so";
      })
      (makeDbConnector {
        package = firebird;
        library = "libfbclient.so";
      })
    ];

    customScript = writers.writeBashBin "heidisql-ldconfig" (
      lib.concatStringsSep "\n" (
        map (
          x: "printf '\t%s (libc6,x86-64) => %s/%s\n' \"${x.library}\" \"${x.path}\" \"${x.library}\""
        ) dbConnectors
      )
    );
  in
  {
    pname = "heidisql";
    version = "12.20";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "HeidiSQL";
      repo = "HeidiSQL";
      tag = "v${finalAttrs.version}";
      hash = "sha256-Ol5JPf1+R47+tennlFsCk/XExH3lQbtQ3dVsxaU6kpU=";
    };

    nativeBuildInputs = [
      fpc
      lazarus-qt6
      qt6Packages.wrapQtAppsHook
      autoPatchelfHook
      writableTmpDirAsHomeHook
      copyDesktopItems
    ];

    buildInputs = [
      qt6Packages.qtbase
      qt6Packages.libqtpas
    ]
    ++ (map (x: x.package) dbConnectors);

    postPatch = ''
      substituteInPlace source/dbconnection.pas \
        --replace-fail "/sbin/ldconfig" "$out/bin/heidisql-ldconfig"
    '';

    buildPhase = ''
      lazbuild \
        --lazarusdir=${lazarus-qt6}/share/lazarus \
        --widgetset=qt6 \
        --build-mode=Release \
        heidisql.lpi
    '';

    installPhase = ''
      runHook preInstall

      install -D out/heidisql $out/bin/heidisql
      install -D ${customScript}/bin/heidisql-ldconfig $out/bin/heidisql-ldconfig
      install -D res/mainicon.png $out/share/icons/hicolor/48x48/apps/heidisql.png

      install -D LICENSE $out/share/licenses/heidisql/LICENSE
      install -D LICENSE-openssl $out/share/licenses/heidisql/LICENSE-openssl
      install -D license.txt $out/share/licenses/heidisql/license.txt

      mkdir -p $out/share/heidisql/{ini,locale}
      install -D extra/ini/* $out/share/heidisql/ini/.
      install -D extra/locale/* $out/share/heidisql/locale/.

      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "heidisql";
        desktopName = "HeidiSQL";
        comment = "A lightweight client for managing MariaDB, MySQL, SQL Server, PostgreSQL, SQLite, Interbase and Firebird, written in Delphi and Lazarus/FreePascal";
        icon = "heidisql";
        exec = "heidisql";
        terminal = false;
        categories = [
          "Qt"
          "Development"
        ];
      })
    ];

    passthru.updateScript = gitUpdater {
      ignoredVersions = "[v0-9.]*-Windows$";
      allowedVersions = "v[0-9]*.[0-9]*";
      rev-prefix = "v";
    };

    meta = {
      mainProgram = "heidisql";
      description = "A lightweight client for managing MariaDB, MySQL, SQL Server, PostgreSQL, SQLite, Interbase and Firebird, written in Delphi and Lazarus/FreePascal";
      homepage = "https://www.heidisql.com/";
      platforms = [ "x86_64-linux" ];
      license = lib.licenses.gpl2;
      maintainers = with lib.maintainers; [ leoflo ];
    };
  }
)
