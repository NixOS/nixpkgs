{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  openjdk11,
  jetbrains,
  makeWrapper,
  gettext,
  copyDesktopItems,
  makeDesktopItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "java-geometry-expert";
  version = "0.87-unstable-2026-02-07";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ADG-Foundation";
    repo = "Java-Geometry-Expert";
    rev = "2db841f928ef77d49ff7de3be93a7e2b2ee1fa09";
    hash = "sha256-Qv1UvAK9h8OzC6JdOKgfZiU4Muc5gEAibj8Dd1eUn6c=";
  };

  # Change links to ADG Foundation's official links
  postPatch = ''
    patch -p1 < flatpak/patch-20260201-official.diff
  '';

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
    gettext
    copyDesktopItems
  ];

  buildInputs = [
    openjdk11
  ];

  gradleFlags = [ "-Dfile.encoding=UTF-8" ];

  gradleBuildTask = "installDist";

  desktopItems = [
    (makeDesktopItem {
      name = "io.github.ADG_Foundation.Java-Geometry-Expert";
      desktopName = "Java Geometry Expert";
      exec = "jgex";
      icon = "jgex";
      comment = "Interactive geometry software and automated theorem prover";
      categories = [
        "Education"
        "Science"
        "Math"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    # remove unneeded windows bat
    rm build/install/jgex/bin/Java-Geometry-Expert.bat

    mkdir -p $out/share/jgex $out/bin
    cp -a build/install/jgex/* $out/share/jgex/

    # The application will search for the examples/ folder in the working directory.
    makeWrapper $out/share/jgex/bin/Java-Geometry-Expert $out/bin/jgex \
      --set JAVA_HOME "${jetbrains.jdk}" \
      --chdir "$out/share/jgex/bin" \
      --prefix JDK_JAVA_OPTIONS " " "-Dswing.defaultlaf=javax.swing.plaf.metal.MetalLookAndFeel"


    mkdir -p $out/share/icons/hicolor/64x64/apps
    mkdir -p $out/share/icons/hicolor/128x128/apps
    mkdir -p $out/share/icons/hicolor/256x256/apps
    mkdir -p $out/share/icons/hicolor/512x512/apps

    cp flatpak/jgex-64.png $out/share/icons/hicolor/64x64/apps/jgex.png
    cp flatpak/jgex-128.png $out/share/icons/hicolor/128x128/apps/jgex.png
    cp flatpak/jgex-256.png $out/share/icons/hicolor/256x256/apps/jgex.png
    cp flatpak/jgex-512.png $out/share/icons/hicolor/512x512/apps/jgex.png

    runHook postInstall
  '';

  meta = with lib; {
    description = "Interactive geometry software and automated theorem prover";
    longDescription = ''
      Java Geometry Expert (JGEX) is a software which combines dynamic geometry software (DGS), automated geometry theorem prover (GTP) and our approach for visually dynamic presentation of proofs. As a dynamic geometry software, JGEX can be used to build dynamic visual models to assist teaching and learning of various mathematical concepts. As an automated reasoning software, we can build dynamic logic models which can do reasoning themselves. As a tool for dynamic presentation of proofs, JGEX is a valuable for teachers and students to write and present proofs of geometry theorems with various dynamic visual effects.
    '';
    license = lib.licenses.gpl3Plus;
    mainProgram = "jgex";
    homepage = "https://github.com/ADG-Foundation/Java-Geometry-Expert";
    maintainers = with lib.maintainers; [ vadgoblin ];
  };
})
