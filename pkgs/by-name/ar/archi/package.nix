{
  lib,
  at-spi2-core,
  autoPatchelfHook,
  cairo,
  copyDesktopItems,
  fetchFromGitHub,
  glib,
  gtk3,
  gtk4,
  jdk21,
  libsecret,
  makeDesktopItem,
  makeWrapper,
  maven,
  nix-update-script,
  nixosTests,
  stdenv,
  stripJavaArchivesHook,
  unzip,
  webkitgtk_4_1,
  wrapGAppsHook3,
}:
let
  platform =
    {
      "x86_64-linux" = {
        jna = "linux-x86-64";
        product = "linux/gtk/x86_64";
        swt = "linux.x86_64";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in

maven.buildMavenPackage (finalAttrs: {
  pname = "archi";
  version = "5.10.0";

  src = fetchFromGitHub {
    owner = "archimatetool";
    repo = "archi";
    tag = "release_${finalAttrs.version}";
    hash = "sha256-tm41GKf7QFLTyZQkLhSuSs0XELcrlEUYfcya2nNHv5g=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  mvnJdk = jdk21;

  mvnParameters = lib.escapeShellArgs [
    "-Dbuild.timestamp=198001010000" # application build timestamp
    "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z" # JAR/ZIP archive timestamps
    "-Pproduct"
  ];

  mvnHash = "sha256-f/qnIpkHDdnVYraTlOucgb1tehUBlTUSfN/Yck0jxeo=";

  mvnFetchExtraArgs = {
    postInstall = ''
      # Tycho needs this metadata for offline dependency resolution.
      # Sort it because entries are emitted in hash-map order.
      sort -o $out/.m2/.meta/p2-artifacts.properties $out/.m2/.meta/p2-artifacts.properties

      # Remove volatile response and fetch timestamps.
      # Keep the cache files because Tycho requires their *.headers files.
      find $out/.m2/.cache -type f -name '*.headers' \
        -exec sed -i -e '/^date=/d' -e '/^FILE-LAST_UPDATED=/d' {} +
    '';
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
    stripJavaArchivesHook
    unzip
    wrapGAppsHook3
  ];

  buildInputs = [
    at-spi2-core
    cairo
    glib
    gtk3
    gtk4
  ];

  # These are dlopen'd rather than being DT_NEEDED entries, so autoPatchelfHook
  # cannot infer them.
  appendRunpaths = [
    "${lib.getLib libsecret}/lib" # reached through JNA by Equinox's keyring provider
    "${lib.getLib webkitgtk_4_1}/lib" # dlopen'd by libswt-webkit-gtk for the browser widget
  ];

  postPatch = ''
    # Source tarballs lack the Git history required by the jgit timestamp provider.
    substituteInPlace pom.xml \
      --replace-fail '<timestampProvider>jgit</timestampProvider>' '<timestampProvider>default</timestampProvider>'
  '';

  # Upstream's tests would need extra work to run at all and still fail in the
  # build environment.
  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec

    # Upstream declares icon.xpm as the Linux launcher icon in archi.product
    # but these PNGs are the same artwork at different sizes, which suits the
    # hicolor theme better than a single size XPM.
    for icon in com.archimatetool.editor/img/app-*.png; do
      name=''${icon##*/app-}; name=''${name%.png} # 16, or 16@2x
      size=''${name%%@*}                          # 16
      scale=''${name#"$size"}                     # empty, or @2x
      install -Dm444 "$icon" \
        "$out/share/icons/hicolor/''${size}x''${size}''${scale%x}/apps/archi.png"
    done

    install -Dm444 ${./mime-info.xml} $out/share/mime/packages/archi.xml

    pushd com.archimatetool.editor.product/target/products/com.archimatetool.editor.product/${platform.product}/Archi

    # Copy everything except what is not needed:
    # - icon.xpm, superseded by the PNGs installed above
    # - artifacts.xml, p2's index for provisioning and self-update
    # - p2/, provisioning metadata for unsupported self-update; the profile
    # snapshots also contain wall-clock times and unordered entries
    cp -r . $out/libexec
    rm $out/libexec/{artifacts.xml,icon.xpm}
    rm -r $out/libexec/p2/

    # Tycho writes the wall clock into otherwise stable generated metadata.
    sed -i '/^#.* UTC [0-9]\{4\}$/d' $out/libexec/configuration/config.ini
    sed -i 's/<config date="[0-9]\+"/<config date="0"/' $out/libexec/configuration/org.eclipse.update/platform.xml

    # Keep only the JNA native for the target platform.
    find $out/libexec/plugins/com.sun.jna_* -type f -name libjnidispatch.so \
      ! -path "*/com/sun/jna/${platform.jna}/*" -delete
    chmod 755 $out/libexec/Archi

    # SWT would otherwise unpack its JNI natives at runtime, bypassing
    # autoPatchelfHook. Unpack them here and point swt.library.path at them
    # instead. The glx and awt natives are excluded because Archi uses neither.
    mkdir -p $out/lib/swt
    unzip -q -o -d $out/lib/swt plugins/org.eclipse.swt.gtk.${platform.swt}_*.jar '*.so' \
      -x '*-glx-*' '*-awt-*'
    substituteInPlace $out/libexec/Archi.ini \
      --replace-fail '-vmargs' "-vmargs
    -Dswt.library.path=$out/lib/swt"

    # Simulate the upstream release layout, where the launcher finds a JVM
    # beside itself, so the wrapper does not have to put a JDK on PATH.
    ln -s ${jdk21.home} $out/libexec/jre

    popd

    runHook postInstall
  '';

  # Wrap manually to keep the hook from also wrapping $out/libexec/Archi, which
  # breaks Eclipse's argv[0]-derived lookup of Archi.ini.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapper $out/libexec/Archi $out/bin/archi "''${gappsWrapperArgs[@]}"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      desktopName = "Archi";
      comment = finalAttrs.meta.description;
      exec = "${finalAttrs.meta.mainProgram} %f";
      icon = "archi";
      categories = [ "Development" ];
      startupWMClass = "Archi";
      mimeTypes = [ "application/x-archimate" ];
    })
  ];

  passthru = {
    tests.archi = nixosTests.archi;

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "release_(.*)"
      ];
    };
  };

  meta = {
    description = "ArchiMate modelling tool";
    homepage = "https://www.archimatetool.com/";
    changelog = "https://github.com/archimatetool/archi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    # Archi itself is built from source but Tycho resolves the Eclipse platform
    # it is assembled onto from a p2 repository, which ships prebuilt bundles
    # and prebuilt SWT/Equinox JNI libraries.
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
      binaryNativeCode
    ];
    mainProgram = "archi";
    maintainers = with lib.maintainers; [ ilkecan ];
    platforms = [ "x86_64-linux" ];
  };
})
