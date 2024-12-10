{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  jdk11,
  gradle_6,
  perl,
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
  ];

  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit version src patches;
    nativeBuildInputs = [
      gradle_6
      perl
    ];
    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --no-daemon assemble
    '';
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
      rm -rf $out/tmp
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-6o3HlBfmpjpmMeiRydOme6fJc8caq8EBRVf3nJq9vqo=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    src
    patches
    ;

  __darwinAllowLocalNetworking = true;

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

  nativeBuildInputs =
    [
      jdk11
      gradle_6
      makeWrapper
      copyDesktopItems
    ]
    ++ lib.optionals stdenv.isDarwin [
      writeDarwinBundle
    ];

  buildPhase = ''
    runHook preBuild

    export GRADLE_USER_HOME=$(mktemp -d)
    substituteInPlace armitage/build.gradle \
      --replace 'mavenCentral()' 'mavenLocal(); maven { url uri("${deps}") }'
    substituteInPlace cortana/build.gradle \
      --replace 'mavenCentral()' 'mavenLocal(); maven { url uri("${deps}") }'
    gradle --offline --no-daemon assemble

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    JAR="$out/share/armitage/armitage.jar"
    install -Dm444 build/armitage.jar $JAR

    install -Dm755 dist/unix/armitage $out/bin/armitage
    substituteInPlace $out/bin/armitage \
      --replace "armitage.jar" "$JAR"
    wrapProgram $out/bin/armitage \
      --prefix PATH : "${
        lib.makeBinPath [
          jdk11
          metasploit
        ]
      }"

    install -Dm755 dist/unix/teamserver $out/bin/teamserver
    substituteInPlace $out/bin/teamserver \
      --replace "armitage.jar" "$JAR"
    wrapProgram $out/bin/teamserver \
      --prefix PATH : "${
        lib.makeBinPath [
          jdk11
          metasploit
        ]
      }"

    install -Dm444 dist/unix/armitage-logo.png $out/share/pixmaps/armitage.png
    ${lib.optionalString stdenv.isDarwin ''
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
