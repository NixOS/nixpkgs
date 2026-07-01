{
  lib,
  flutter,
  fetchFromGitHub,
  jdk17,
}:

flutter.buildFlutterApplication rec {
  pname = "knitcalc";
  version = "1.8.28+51";

  src = fetchFromGitHub {
    owner = "dmezhnov";
    repo = "knitcalc";
    tag = "v${version}";
    hash = "sha256-L5pC4wIZ7GqPTx0xYdlgG56yLpeSmwpWNtrZqx3t4lQ=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  # The jni plugin compiles libdartjni.so against JNI headers.
  nativeBuildInputs = [ jdk17 ];

  postInstall = ''
    install -Dm644 packaging/flatpak/io.github.dmezhnov.knitcalc.desktop \
      -t $out/share/applications
    install -Dm644 packaging/flatpak/io.github.dmezhnov.knitcalc.png \
      $out/share/icons/hicolor/256x256/apps/io.github.dmezhnov.knitcalc.png
    install -Dm644 packaging/flatpak/io.github.dmezhnov.knitcalc.metainfo.xml \
      -t $out/share/metainfo
  '';

  meta = {
    description = "Knitting calculator";
    longDescription = ''
      Gauge conversion, increases/decreases distribution, yarn estimation
      and project notes with photos.
    '';
    homepage = "https://github.com/dmezhnov/knitcalc";
    changelog = "https://github.com/dmezhnov/knitcalc/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dmezhnov ];
    mainProgram = "knitcalc";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
