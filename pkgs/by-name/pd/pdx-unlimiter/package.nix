{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  runCommand,
  gradle_8,
  jdk21,
  glib,
  libGL,
  gtk3,
  libXt,
  libXtst,
  libXxf86vm,
  pdx-unlimiter,
}:
let
  jdk_jfx = (jdk21.override { enableJavaFX = true; });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pdx-unlimiter";
  version = "2.13.17";

  src = fetchFromGitHub {
    owner = "crschnick";
    repo = "pdx_unlimiter";
    tag = finalAttrs.version;
    hash = "sha256-3yykzTK3mfKJekbUMzsyxnK+OPrzilavvKo5CbjJ1S8=";
  };

  nativeBuildInputs = [
    gradle_8
    jdk_jfx
    copyDesktopItems
  ];

  buildInputs = [
    libXt
    libXtst
    libXxf86vm
    gtk3
    glib
    libGL
    jdk_jfx
  ];

  mitmCache = gradle_8.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./gradle_deps.json;
  };

  gradleBuildTask = "jpackage";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/{opt,bin,share/icons}
    cp -r build/dist/Pdx-Unlimiter/* "$out/opt"
    cp "$out/opt/resources/logo.png" "$out/share/icons"

    cat << EOF > "$out/bin/pdx-unlimiter"
    #!/usr/bin/env bash
    export JAVA_HOME="${jdk_jfx}/lib/openjdk"
    export LD_LIBRARY_PATH="${jdk_jfx}/lib/openjdk/lib:${gtk3}/lib:${glib.out}/lib:${libXxf86vm}/lib:${libGL}/lib:${libXtst}/lib:${libXt}/lib:$LD_LIBRARY_PATH"
    "$out/opt/bin/Pdx-Unlimiter" "\$@"
    EOF

    chmod +x "$out/bin/pdx-unlimiter"

    runHook postInstall
  '';

  passthru.tests = {
    help = runCommand "${finalAttrs.pname}-test-help" { } ''
      # Tests that the help text is returned
      mkdir $out
      ${pdx-unlimiter}/bin/pdx-unlimiter help > $out/help.txt
      grep "Runs the Pdx-Unlimiter application." $out/help.txt
    '';
  };

  desktopItems = [
    (makeDesktopItem {
      name = "Pdx-Unlimiter";
      desktopName = "Pdx-Unlimiter";
      comment = "A smart savegame manager, editor, and toolbox for all current major Paradox Grand Strategy games";
      exec = "pdx-unlimiter";
      icon = "logo";
    })
  ];

  meta = {
    description = "Smart savegame manager, editor, and toolbox for all current major Paradox Grand Strategy games";
    mainProgram = "pdx-unlimiter";
    longDescription = ''
      The Pdx-Unlimiter is a tool for all major Paradox Grand Strategy games that provides a powerful and smart savegame
      manager to quickly organize and play all of your savegames with ease. Furthermore, it also comes with an Ironman
      converter, a powerful savegame editor, some savescumming tools, integrations for various other great community-made
      tools, and full support for the following games:
      - Victoria III
      - Europa Universalis IV
      - Crusader Kings III
      - Hearts of Iron IV
      - Stellaris
      - Crusader Kings II
      - Victoria II
    '';
    homepage = "https://github.com/crschnick/pdx_unlimiter";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mabster314 ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
    platforms = lib.platforms.all;
    badPlatforms = lib.platforms.darwin;
  };
})
