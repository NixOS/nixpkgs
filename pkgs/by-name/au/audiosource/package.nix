{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  makeWrapper,
  python3,
  android-tools,
  pulseaudio,
  coreutils,
}:

let
  audiosource-apk = fetchurl {
    url = "https://github.com/gdzx/audiosource/releases/download/v1.4/audiosource.apk";
    hash = "sha256-vDIF+NZ3JgTT67Dem4qeajWsA5m/MFt2nRDpWUqC9aU=";
  };
in
stdenv.mkDerivation rec {
  pname = "audiosource";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "gdzx";
    repo = "audiosource";
    rev = "v${version}";
    hash = "sha256-SlX8gjs7X5jfoeU6pyk4n8f6oMJgneGVt0pmFs48+mQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''

    # Remove source build logic unimplemented in package
    sed -i '5,13d' audiosource
    sed -i '2i AUDIOSOURCE_APK=''${AUDIOSOURCE_APK:-"@apkPath@"}' audiosource
    sed -i '/^build() {/,/^}/d' audiosource
    sed -i '/^_release() {/,/^}/d' audiosource

    # Update case statement accordingly
    substituteInPlace audiosource \
      --replace-fail 'build|install|run|volume|_release' 'install|run|volume'

    # Micro patch to fix ADB flags syntax error
    substituteInPlace audiosource \
      --replace-fail 'adb install -rtg' 'adb install -r -t -g' \
      --replace-fail 'adb install -tg'  'adb install -t -g' \

    # Update the help text
    sed -i '/build.*Build Audio Source APK/d' audiosource
    sed -i '/AUDIOSOURCE_PROFILE.*Build profile/d' audiosource
    sed -i 's|.*install.*Install Audio Source to Android device.*|   install       Install the bundled APK to your device|' audiosource
    sed -i 's|.*AUDIOSOURCE_APK.*APK path.*|   AUDIOSOURCE_APK      APK path (default: @apkPath@)|' audiosource
    sed -i 's|Usage: ./audiosource|Usage: audiosource|' audiosource

    # Substitute apk path
    substituteInPlace audiosource \
      --replace-fail "@apkPath@" "$out/share/audiosource/audiosource.apk"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/audiosource
    cp ${audiosource-apk} $out/share/audiosource/audiosource.apk
    cp audiosource $out/bin/audiosource
    chmod +x $out/bin/audiosource

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/audiosource \
      --prefix PATH : ${
        lib.makeBinPath [
          python3
          android-tools
          pulseaudio
          coreutils
        ]
      }
  '';

  meta = {
    description = "Use an Android device as a USB microphone";
    homepage = "https://github.com/gdzx/audiosource";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ikci ];
    mainProgram = "audiosource";
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
}
