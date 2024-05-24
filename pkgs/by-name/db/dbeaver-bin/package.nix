{ lib
, stdenvNoCC
, fetchurl
, makeWrapper
, openjdk17
, gnused
, autoPatchelfHook
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dbeaver-bin";
  version = "24.0.5";

  nativeBuildInputs = [
    makeWrapper
    gnused
    autoPatchelfHook
  ];

  src =
    let
      inherit (stdenvNoCC.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        x86_64-linux = "linux.gtk.x86_64-nojdk.tar.gz";
        aarch64-linux = "linux.gtk.aarch64-nojdk.tar.gz";
      };
      hash = selectSystem {
        x86_64-linux = "sha256-q6VIr55hXn47kZrE2i6McEOfp2FBOvwB0CcUnRHFMZs=";
        aarch64-linux = "sha256-Xn3X1C31UALBAsZIGyMWdp0HNhJEm5N+7Go7nMs8W64=";
      };
    in
    fetchurl {
      url = "https://github.com/dbeaver/dbeaver/releases/download/${finalAttrs.version}/dbeaver-ce-${finalAttrs.version}-${suffix}";
      inherit hash;
    };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
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
    platforms = platforms.linux;
    maintainers = with maintainers; [ gepbird mkg20001 ];
    mainProgram = "dbeaver";
  };
})
