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
  version = "24.3.5";

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
        x86_64-linux = "sha256-Kt+CPPgeqKMxZZeWG3NjNKdlcQFyS9NvEaAQSI9c5CI=";
        aarch64-linux = "sha256-9O0BhsrhVMpf3FMzqZeaNrCKdSscsOrLmo6Mq42aRLU=";
        x86_64-darwin = "sha256-4uZrlgjHJz7zOgGn7mTRtz/qjlvzBglXAVcjf7SDmCs=";
        aarch64-darwin = "sha256-Hm9215hcoNEc/amTQ9mBX2wl95aTCF1/T+5crctbaeA=";
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

  preInstall = ''
    # most directories are for different architectures, only keep what we need
    shopt -s extglob
    pushd ${lib.optionalString stdenvNoCC.hostPlatform.isDarwin "Contents/Eclipse/"}plugins/com.sun.jna_5.15.0.v20240915-2000/com/sun/jna/
    rm -r !(ptr|internal|linux-x86-64|linux-aarch64|darwin-x86-64|darwin-aarch64)/
    popd
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
        # for some reason it's missing from the aarch64 build
        if [ -e $out/opt/dbeaver/dbeaver.png ]; then
          ln -s $out/opt/dbeaver/dbeaver.png $out/share/icons/hicolor/256x256/apps/dbeaver.png
        fi

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

  meta = {
    homepage = "https://dbeaver.io/";
    changelog = "https://github.com/dbeaver/dbeaver/releases/tag/${finalAttrs.version}";
    description = "Universal SQL Client for developers, DBA and analysts. Supports MySQL, PostgreSQL, MariaDB, SQLite, and more";
    longDescription = ''
      Free multi-platform database tool for developers, SQL programmers, database
      administrators and analysts. Supports all popular databases: MySQL,
      PostgreSQL, MariaDB, SQLite, Oracle, DB2, SQL Server, Sybase, MS Access,
      Teradata, Firebird, Derby, etc.
    '';
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.asl20;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      gepbird
      mkg20001
      yzx9
    ];
    mainProgram = "dbeaver";
  };
})
