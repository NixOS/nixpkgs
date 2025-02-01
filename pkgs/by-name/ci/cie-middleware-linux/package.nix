{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  stripJavaArchivesHook,
  meson,
  ninja,
  pkg-config,
  gradle_8,
  curl,
  cryptopp,
  fontconfig,
  jre,
  libxml2,
  openssl,
  pcsclite,
  podofo,
  ghostscript,
}:

let
  pname = "cie-middleware-linux";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "M0rf30";
    repo = pname;
    rev = version;
    sha256 = "sha256-M3Xwg3G2ZZhPRV7uhFVXQPyvuuY4zI5Z+D/Dt26KVM0=";
  };

  gradle = gradle_8;

  # Shared libraries needed by the Java application
  libraries = lib.makeLibraryPath [ ghostscript ];

in

stdenv.mkDerivation {
  inherit pname src version;

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    makeWrapper
    stripJavaArchivesHook
    meson
    ninja
    pkg-config
    gradle
  ];

  buildInputs = [
    cryptopp
    fontconfig
    podofo
    openssl
    pcsclite
    curl
    libxml2
  ];

  patches = [ ./use-system-podofo.patch ];

  postPatch = ''
    # substitute the cieid command with this $out/bin/cieid
    substituteInPlace libs/pkcs11/src/CSP/AbilitaCIE.cpp \
      --replace 'file = "cieid"' 'file = "'$out'/bin/cieid"'
  '';

  # Note: we use pushd/popd to juggle between the
  # libraries and the Java application builds.
  preConfigure = "pushd libs";

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  gradleFlags = [
    "-Dorg.gradle.java.home=${jre}"
    "--build-file"
    "cie-java/build.gradle"
  ];

  gradleBuildTask = "standalone";

  buildPhase = ''
    runHook preBuild

    ninjaBuildPhase
    pushd ../..
    gradleBuildPhase
    popd

    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    mesonCheckPhase
    pushd ../..
    gradleCheckPhase
    popd

    runHook postCheck
  '';

  postInstall = ''
    popd

    # Install the Java application
    install -Dm755 cie-java/build/libs/CIEID-standalone.jar \
                   "$out/share/cieid/cieid.jar"

    # Create a wrapper
    mkdir -p "$out/bin"
    makeWrapper "${jre}/bin/java" "$out/bin/cieid" \
      --add-flags "-Djna.library.path='$out/lib:${libraries}'" \
      --add-flags '-Dawt.useSystemAAFontSettings=on' \
      --add-flags "-cp $out/share/cieid/cieid.jar" \
      --add-flags "it.ipzs.cieid.MainApplication"

    # Install other files
    install -Dm644 data/cieid.desktop "$out/share/applications/cieid.desktop"
    install -Dm755 data/logo.png "$out/share/pixmaps/cieid.png"
    install -Dm644 LICENSE "$out/share/licenses/cieid/LICENSE"
  '';

  preGradleUpdate = "cd ../..";

  meta = with lib; {
    homepage = "https://github.com/M0Rf30/cie-middleware-linux";
    description = "Middleware for the Italian Electronic Identity Card (CIE)";
    longDescription = ''
      Software for the usage of the Italian Electronic Identity Card (CIE).
      Access to PA services, signing and verification of documents

      Warning: this is an unofficial fork because the original software, as
      distributed by the Italian government, is essentially lacking a build
      system and is in violation of the license of the PoDoFo library.
    '';
    license = licenses.bsd3;
    platforms = platforms.unix;
    # Note: fails due to a lot of broken type conversions
    badPlatforms = platforms.darwin;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
