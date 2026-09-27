{
  lib,
  flutter341,
  fetchFromGitHub,
  jdk17,
}:

flutter341.buildFlutterApplication (finalAttrs: {
  pname = "knitcalc";
  version = "1.8.79+102";

  src = fetchFromGitHub {
    owner = "dmezhnov";
    repo = "knitcalc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kyzvs95rc4pJKVstKQFVHs/S9UyaXk7O4haW3qo7Aq8=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  strictDeps = true;
  __structuredAttrs = true;

  # buildDartApplication passes the lock with passAsFile, which Nix ignores when
  # __structuredAttrs is set, leaving $pubspecLockFilePath empty; going through
  # env works either way (YAML is a superset of JSON, so the .json file serves as
  # a pubspec.lock). Removable once NixOS/nixpkgs#553331 lands.
  env.pubspecLockFilePath = "${./pubspec.lock.json}";

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
    changelog = "https://github.com/dmezhnov/knitcalc/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dmezhnov ];
    mainProgram = "knitcalc";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
