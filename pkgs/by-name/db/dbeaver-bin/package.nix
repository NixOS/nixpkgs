# dbeaver doesn't seem feasible to package from source, see https://github.com/NixOS/nixpkgs/pull/311888
{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  makeWrapper,
  openjdk21,
  gnused,
  autoPatchelfHook,
  darwin,
  wrapGAppsHook3,
  gtk3,
  glib,
  webkitgtk_4_1,
  glib-networking,
  override_xmx ? "1024m",
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dbeaver-bin";
  version = "25.3.3";

  src =
    let
      inherit (stdenvNoCC.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        x86_64-linux = "linux.gtk.x86_64.tar.gz";
        aarch64-linux = "linux.gtk.aarch64.tar.gz";
        x86_64-darwin = "macos-x86_64.dmg";
        aarch64-darwin = "macos-aarch64.dmg";
      };
      hash = selectSystem {
        x86_64-linux = "sha256-dzLwpP/EBYqgsLc5B5HwZvDQUjgvB11/kSPsQ2lBF4g=";
        aarch64-linux = "sha256-DI8dgcFs3kVrXAx0DVKKA2+SNiQ3ZN3JFwJvkqzQ7Fk=";
        x86_64-darwin = "sha256-r1T3OU+98DBXgI3Px/nNe7uv7dHzBe+Vl5w2cAaBFMI=";
        aarch64-darwin = "sha256-OwwTOKHemQQKpPmMXo0yzD1MNqqHh+ELeWW/MmK9UfA=";
      };
    in
    fetchurl {
      url = "https://github.com/dbeaver/dbeaver/releases/download/${finalAttrs.version}/dbeaver-ce-${finalAttrs.version}-${suffix}";
      inherit hash;
    };

  sourceRoot = lib.optional stdenvNoCC.hostPlatform.isDarwin "DBeaver.app";

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals (!stdenvNoCC.hostPlatform.isDarwin) [
    gnused
    wrapGAppsHook3
    autoPatchelfHook
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
    undmg
    darwin.autoSignDarwinBinariesHook
  ];

  dontConfigure = true;
  dontBuild = true;

  prePatch = ''
    substituteInPlace ${lib.optionalString stdenvNoCC.hostPlatform.isDarwin "Contents/Eclipse/"}dbeaver.ini \
      --replace-fail '-Xmx1024m' '-Xmx${override_xmx}'
  ''
  # remove the bundled JRE configuration on Darwin
  # dont use substituteInPlace here because it would match "-vmargs"
  + lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
    sed -i -e '/^-vm$/ { N; d; }' Contents/Eclipse/dbeaver.ini
  '';

  preInstall = ''
    # most directories are for different architectures, only keep what we need
    shopt -s extglob
    pushd ${lib.optionalString stdenvNoCC.hostPlatform.isDarwin "Contents/Eclipse/"}plugins/com.sun.jna_*/com/sun/jna/
    rm -r !(ptr|internal|linux-x86-64|linux-aarch64|darwin-x86-64|darwin-aarch64)/
    popd

    # remove the bundled JRE
    rm -r ${lib.optionalString stdenvNoCC.hostPlatform.isDarwin "Contents/Eclipse/"}jre/
  '';

  installPhase =
    if !stdenvNoCC.hostPlatform.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/opt/dbeaver $out/bin
        cp -r * $out/opt/dbeaver
        makeWrapper $out/opt/dbeaver/dbeaver $out/bin/dbeaver \
          --prefix PATH : "${openjdk21}/bin" \
          --set JAVA_HOME "${openjdk21.home}" \
          --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
          --prefix LD_LIBRARY_PATH : "$out/lib:${
            lib.makeLibraryPath [
              gtk3
              glib
              webkitgtk_4_1
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
        wrapProgram $out/Applications/dbeaver.app/Contents/MacOS/dbeaver \
          --prefix PATH : "${openjdk21}/bin" \
          --set JAVA_HOME "${openjdk21.home}"
        makeWrapper $out/{Applications/dbeaver.app/Contents/MacOS/dbeaver,bin/dbeaver}

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
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      gepbird
      mkg20001
      staticdev
      yzx9
    ];
    mainProgram = "dbeaver";
  };
})
