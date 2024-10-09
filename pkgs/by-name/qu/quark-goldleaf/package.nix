{ lib
, jdk
, maven
, fetchFromGitHub
, fetchpatch
, makeDesktopItem
, copyDesktopItems
, imagemagick
, wrapGAppsHook3
, gtk3
}:

let
  jdk' = jdk.override { enableJavaFX = true; };
in
maven.buildMavenPackage rec {
  pname = "quark-goldleaf";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "XorTroll";
    repo = "Goldleaf";
    rev = version;
    hash = "sha256-gagIQGOiygJ0Onm0SrkbFWaovqWX2WJNx7LpSRheCLM=";
  };

  sourceRoot = "${src.name}/Quark";

  patches = [
    ./fix-maven-plugin-versions.patch
    ./remove-pom-jfx.patch
    (fetchpatch {
      name = "fix-config-path.patch";
      url = "https://github.com/XorTroll/Goldleaf/commit/714ecc2755df9c1252615ad02cafff9c0311a739.patch";
      hash = "sha256-4j+6uLIOdltZ4XIb3OtOzZg9ReH9660gZMMNQpHnn4o=";
      relative = "Quark";
    })
  ];

  mvnJdk = jdk';
  mvnHash = "sha256-gA3HsQZFa2POP9cyJLb1l8t3hrJYzDowhJU+5Xl79p4=";

  # set fixed build timestamp for deterministic jar
  mvnParameters = "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z";

  nativeBuildInputs = [
    imagemagick # for icon conversion
    copyDesktopItems
    wrapGAppsHook3
  ];

  buildInputs = [ gtk3 ];

  # don't double-wrap
  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 ${./99-quark-goldleaf.rules} $out/etc/udev/rules.d/99-quark-goldleaf.rules
    install -Dm644 target/Quark.jar $out/share/java/quark-goldleaf.jar

    for size in 16 24 32 48 64 128; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -resize "$size"x"$size" src/main/resources/Icon.png $out/share/icons/hicolor/"$size"x"$size"/apps/quark-goldleaf.png
    done

    runHook postInstall
  '';

  postFixup = ''
    # This is in postFixup because gappsWrapperArgs are generated during preFixup
    makeWrapper ${jdk'}/bin/java $out/bin/quark-goldleaf \
        "''${gappsWrapperArgs[@]}" \
        --add-flags "-jar $out/share/java/quark-goldleaf.jar"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "quark-goldleaf";
      exec = "quark-goldleaf";
      icon = "quark-goldleaf";
      desktopName = "Quark";
      comment = meta.description;
      terminal = false;
      categories = [ "Utility" "FileTransfer" ];
      keywords = [ "nintendo" "switch" "goldleaf" ];
    })
  ];

  meta = {
    changelog = "https://github.com/XorTroll/Goldleaf/releases/tag/${src.rev}";
    description = "A GUI tool for transfering files between a computer and a Nintendo Switch running Goldleaf";
    homepage = "https://github.com/XorTroll/Goldleaf#quark-and-remote-browsing";
    longDescription = ''
      ${meta.description}

      For the program to work properly, you will have to install Nintendo Switch udev rules.

      You can either do this by enabling the NixOS module:

      `programs.quark-goldleaf.enable = true;`

      or by adding the package manually to udev packages:

      `services.udev.packages = [ pkgs.quark-goldleaf ];
    '';
    license = lib.licenses.gpl3Only;
    mainProgram = "quark-goldleaf";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}

