{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  jdk11,
  gradle_8,
  metasploit,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  writeDarwinBundle,
}:

let
  pname = "armitage";
  version = "unstable-2022-12-05";

  src = fetchFromGitHub {
    owner = "r00t0v3rr1d3";
    repo = "armitage";
    rev = "991244e9a0c0fc9302e48c4e708347c315f78b13";
    hash = "sha256-0ik20wzE0cf6cC/HY6RwMHqkvqPFpZmOUyZyb5H3SHg=";
  };

  patches = [
    (fetchurl {
      name = "Remove-mentions-of-old-metasploit-versions.patch";
      url = "https://gitlab.com/kalilinux/packages/armitage/-/raw/042beb7494a10227761ecb3ddabf4019bbb78681/debian/patches/Remove-mentions-of-old-metasploit-versions.patch";
      hash = "sha256-VUey/e8kcBWqAxYTfIXoyTAoDR/UKZKqBJAKmdabArY=";
    })
    (fetchurl {
      name = "Update-postgresql-version-to-support-scram-sha-256.patch";
      url = "https://gitlab.com/kalilinux/packages/armitage/-/raw/042beb7494a10227761ecb3ddabf4019bbb78681/debian/patches/Update-postgresql-version-to-support-scram-sha-256.patch";
      hash = "sha256-ZPvcRoUCrq32g0Mw8+EhNl8DlI+jMYUlFyPW1VScgzc=";
    })
    (fetchurl {
      name = "fix-launch-script.patch";
      url = "https://gitlab.com/kalilinux/packages/armitage/-/raw/042beb7494a10227761ecb3ddabf4019bbb78681/debian/patches/fix-launch-script.patch";
      hash = "sha256-I6T7iwShQLn+ZHuKa117VOlItXjY4/51RDbjvNJEW/4=";
    })
    (fetchurl {
      name = "fix-meterpreter.patch";
      url = "https://gitlab.com/kalilinux/packages/armitage/-/raw/042beb7494a10227761ecb3ddabf4019bbb78681/debian/patches/fix-meterpreter.patch";
      hash = "sha256-p4fs5xFdC2apW0U8x8u9S4p5gq3Eiv+0E4CGccQZYKY=";
    })
    # Update for Gradle 8 (https://github.com/r00t0v3rr1d3/armitage/pull/1)
    ./gradle-8.patch
  ];

  # "Deprecated Gradle features were used in this build, making it incompatible with Gradle 9.0."
  gradle = gradle_8;

in
stdenv.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    src
    patches
    ;

  desktopItems = [
    (makeDesktopItem {
      name = "armitage";
      desktopName = "Armitage";
      exec = "armitage";
      icon = "armitage";
      comment = finalAttrs.meta.description;
      categories = [
        "Network"
        "Security"
      ];
      startupNotify = false;
    })
  ];

  nativeBuildInputs = [
    jdk11
    gradle
    makeWrapper
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    writeDarwinBundle
  ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  installPhase = ''
    runHook preInstall

    JAR="$out/share/armitage/armitage.jar"
    install -Dm444 build/armitage.jar $JAR

    install -Dm755 dist/unix/armitage $out/bin/armitage
    substituteInPlace $out/bin/armitage \
      --replace-fail "armitage.jar" "$JAR"
    wrapProgram $out/bin/armitage \
      --prefix PATH : "${
        lib.makeBinPath [
          jdk11
          metasploit
        ]
      }"

    install -Dm755 dist/unix/teamserver $out/bin/teamserver
    substituteInPlace $out/bin/teamserver \
      --replace-fail "armitage.jar" "$JAR"
    wrapProgram $out/bin/teamserver \
      --prefix PATH : "${
        lib.makeBinPath [
          jdk11
          metasploit
        ]
      }"

    install -Dm444 dist/unix/armitage-logo.png $out/share/pixmaps/armitage.png
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/Applications/Armitage.app/Contents/MacOS"
      mkdir -p "$out/Applications/Armitage.app/Contents/Resources"
      cp dist/mac/Armitage.app/Contents/Resources/macIcon.icns $out/Applications/Armitage.app/Contents/Resources
      write-darwin-bundle $out Armitage armitage macIcon
    ''}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Graphical cyber attack management tool for Metasploit";
    homepage = "https://github.com/r00t0v3rr1d3/armitage";
    license = licenses.bsd3;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
    mainProgram = "armitage";
  };
})
