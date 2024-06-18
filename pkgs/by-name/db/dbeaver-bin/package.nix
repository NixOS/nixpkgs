{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  makeWrapper,
  openjdk17,
  gnused,
  autoPatchelfHook,
  wrapGAppsHook3,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dbeaver-bin";
  version = "24.1.0";

  src =
    let
      inherit (stdenvNoCC.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        x86_64-linux = "linux.gtk.x86_64-nojdk.tar.gz";
        aarch64-linux = "linux.gtk.aarch64-nojdk.tar.gz";
        x86_64-darwin = "macos-x86_64.dmg";
        aarch64-darwin = "macos-aarch64.dmg";
      };
      hash = selectSystem {
        x86_64-linux = "sha256-cJcjUoZSpD87jy4GGIxMinZW4gxRZfcGO0GdGUGXI6g=";
        aarch64-linux = "sha256-96t/T/VzzzaSWJbPBb1CH2FXqfhiH1d0MjRoPsRMRwo=";
        x86_64-darwin = "sha256-8xqSL8fTveg1Y5huBTYZLyubajt27h4XUBzyYVF394A=";
        aarch64-darwin = "sha256-r7WqJrNF1IgQHx3Na1fGk0ywsfh5t4Dl/u8hH6CPuoE=";
      };
    in
    fetchurl {
      url = "https://github.com/dbeaver/dbeaver/releases/download/${finalAttrs.version}/dbeaver-ce-${finalAttrs.version}-${suffix}";
      inherit hash;
    };

  sourceRoot = lib.optional stdenvNoCC.isDarwin "dbeaver.app";

  nativeBuildInputs =
    [ makeWrapper ]
    ++ lib.optionals (!stdenvNoCC.isDarwin) [
      gnused
      wrapGAppsHook3
      autoPatchelfHook
    ]
    ++ lib.optionals stdenvNoCC.isDarwin [ undmg ];

  dontConfigure = true;
  dontBuild = true;

  installPhase =
    if !stdenvNoCC.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/opt/dbeaver $out/bin
        cp -r * $out/opt/dbeaver
        makeWrapper $out/opt/dbeaver/dbeaver $out/bin/dbeaver \
          --prefix PATH : "${openjdk17}/bin" \
          --set JAVA_HOME "${openjdk17.home}"

        mkdir -p $out/share/icons/hicolor/256x256/apps
        ln -s $out/opt/dbeaver/dbeaver.png $out/share/icons/hicolor/256x256/apps/dbeaver.png

        mkdir -p $out/share/applications
        ln -s $out/opt/dbeaver/dbeaver-ce.desktop $out/share/applications/dbeaver.desktop

        substituteInPlace $out/opt/dbeaver/dbeaver-ce.desktop \
          --replace-fail "/usr/share/dbeaver-ce/dbeaver.png" "dbeaver" \
          --replace-fail "/usr/share/dbeaver-ce/dbeaver" "$out/bin/dbeaver"

        sed -i '/^Path=/d' $out/share/applications/dbeaver.desktop

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        mkdir -p $out/{Applications/dbeaver.app,bin}
        cp -R . $out/Applications/dbeaver.app
        makeWrapper $out/{Applications/dbeaver.app/Contents/MacOS,bin}/dbeaver \
          --prefix PATH : "${openjdk17}/bin" \
          --set JAVA_HOME "${openjdk17.home}"

        runHook postInstall
      '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://dbeaver.io/";
    description = "Universal SQL Client for developers, DBA and analysts. Supports MySQL, PostgreSQL, MariaDB, SQLite, and more";
    longDescription = ''
      Free multi-platform database tool for developers, SQL programmers, database
      administrators and analysts. Supports all popular databases: MySQL,
      PostgreSQL, MariaDB, SQLite, Oracle, DB2, SQL Server, Sybase, MS Access,
      Teradata, Firebird, Derby, etc.
    '';
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      gepbird
      mkg20001
      yzx9
    ];
    mainProgram = "dbeaver";
  };
})
