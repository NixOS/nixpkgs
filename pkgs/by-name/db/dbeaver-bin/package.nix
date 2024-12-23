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
  gtk3,
  glib,
  webkitgtk_4_0,
  glib-networking,
  override_xmx ? "1024m",
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dbeaver-bin";
  version = "24.3.0";

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
        x86_64-linux = "sha256-7tmz6ThT6oH2eMRl5XTf1+nr/ufDlp4BvGyKFICiTRw=";
        aarch64-linux = "sha256-idnTeh37Ew6fg1gdJaoFF+wpgoShcJZokmWsid6g3ow=";
        x86_64-darwin = "sha256-P1XseM1Al7y1JFVe/8VCIE84nMT4l9KF+Ik+rHjrv20=";
        aarch64-darwin = "sha256-Xl4D8qTwB0tccuXqon4DApOOM95swxbfwSTD8gqc7jo=";
      };
    in
    fetchurl {
      url = "https://github.com/dbeaver/dbeaver/releases/download/${finalAttrs.version}/dbeaver-ce-${finalAttrs.version}-${suffix}";
      inherit hash;
    };

  sourceRoot = lib.optional stdenvNoCC.hostPlatform.isDarwin "DBeaver.app";

  nativeBuildInputs =
    [ makeWrapper ]
    ++ lib.optionals (!stdenvNoCC.hostPlatform.isDarwin) [
      gnused
      wrapGAppsHook3
      autoPatchelfHook
    ]
    ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [ undmg ];

  dontConfigure = true;
  dontBuild = true;

  prePatch = ''
    substituteInPlace ${lib.optionalString stdenvNoCC.hostPlatform.isDarwin "Contents/Eclipse/"}dbeaver.ini \
      --replace-fail '-Xmx1024m' '-Xmx${override_xmx}'
  '';

  installPhase =
    if !stdenvNoCC.hostPlatform.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/opt/dbeaver $out/bin
        cp -r * $out/opt/dbeaver
        makeWrapper $out/opt/dbeaver/dbeaver $out/bin/dbeaver \
          --prefix PATH : "${openjdk17}/bin" \
          --set JAVA_HOME "${openjdk17.home}" \
          --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
          --prefix LD_LIBRARY_PATH : "$out/lib:${
            lib.makeLibraryPath [
              gtk3
              glib
              webkitgtk_4_0
              glib-networking
            ]
          }"

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
