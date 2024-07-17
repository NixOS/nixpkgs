{
  stdenv,
  lib,
  fetchurl,
  zlib,
  libXext,
  libX11,
  libXrender,
  libXtst,
  libXi,
  freetype,
  alsa-lib,
  jdk21,
  openjfx21,
  autoPatchelfHook,
  makeBinaryWrapper,
  wrapGAppsHook3,
}:

let
  repo = "olvid";

  javafxModules = [
    "swing"
    "controls"
    "media"
    "fxml"
    "graphics"
    "base"
  ];

  classpath =
    lib.concatMap (mod: [
      "${openjfx21}/modules_src/javafx.${mod}/module-info.java"
      "${openjfx21}/modules/javafx.${mod}"
      "${openjfx21}/modules_libs/javafx.${mod}"
    ]) javafxModules
    ++ [ "$out/share/${repo}/*" ];

  jvmArgs = [
    "-cp"
    (lib.concatStringsSep ":" classpath)
    "-Djpackage.app-version=$version"
    "-Dolvid.sqlcipher=true"
    "-Dolvid.dev=false"
    "-Dolvid.packaged=true"
    "-Dolvid.multiuser=false"
    "-Dolvid.debug=false"
    "-Dolvid.version=$version"
    "-Djava.net.useSystemProxies=true"
    "-Djava.library.path=$out/lib/"
    "-Xss8M"
    "-XX:+ShowCodeDetailsInExceptionMessages"
    "--add-opens=java.desktop/java.awt=ALL-UNNAMED"
    "--add-opens=java.desktop/java.awt.geom=ALL-UNNAMED"
    "--add-opens=java.desktop/sun.awt.geom=ALL-UNNAMED"
    "--add-opens=java.base/java.util=ALL-UNNAMED"
    "--add-opens=java.desktop/javax.swing=ALL-UNNAMED"
    "--add-opens=java.desktop/sun.awt.shell=ALL-UNNAMED"
  ];
in

stdenv.mkDerivation (finalAttrs: {
  pname = "olvid";
  version = "1.5.2";

  dontUnpack = true;
  dontWrapGApps = true;

  src = fetchurl {
    url = "https://static.olvid.io/linux/${repo}-${finalAttrs.version}.tar.gz";
    hash = "sha256-WjIOk3dPSXQdAR2fdXseV0NdOjld0PzyqnUx/VbvQio=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    zlib
    libXext
    libX11
    libXrender
    libXtst
    libXi
    freetype
    alsa-lib
  ];

  installPhase = ''
    runHook preInstall

    install -dm755 "$out/share/${repo}"
    tar -xf "$src" -C "$out/share/${repo}" --wildcards --strip-components 3 olvid/lib/app/'*.jar'

    install -dm755 "$out/lib"
    tar -xf "$src" -C "$out/lib" --strip-components 4 olvid/lib/runtime/lib/

    install -dm755 "$out/bin"
    makeBinaryWrapper ${jdk21}/bin/java $out/bin/${repo} \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "${lib.concatStringsSep " " jvmArgs} io.olvid.windows.messenger.start_up.Launcher"

    runHook postInstall
  '';

  meta = with lib; {
    description = "The secure french messenger";
    homepage = "https://www.olvid.io";
    license = licenses.agpl3Only;
    mainProgram = "olvid";
    maintainers = with maintainers; [ rookeur ];
    platforms = platforms.linux;
  };
})
