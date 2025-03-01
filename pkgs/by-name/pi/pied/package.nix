{
  lib,
  fetchFromGitHub,
  flutter327,
  gst_all_1,
}:

flutter327.buildFlutterApplication rec {
  pname = "pied";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Elleo";
    repo = "pied";
    tag = "v${version}";
    hash = "sha256-I2p3GIb54r9r/phbKJsz/cFw1ECdwZ2RnCYVxjsHzg0=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;
  patches = [ ./patches/add_piper_tts-path.patch ];

  strictDeps = true;

  buildInputs = [
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  postInstall = ''
    install -D flatpak/com.mikeasoft.pied.desktop -t $out/share/applications
    install -D flatpak/com.mikeasoft.pied.png -t $out/share/pixmaps
  '';

  meta = {
    description = "Piper text-to-speech voice manager for use with Speech Dispatcher";
    homepage = "https://github.com/Elleo/pied";
    changelog = "https://github.com/Elleo/pied/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "pied";
    badPlatforms = [
      # Silently fails in dartConfigHook
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
