{
  lib,
  fetchFromGitHub,
  flutter327,

  libunwind,
  gst_all_1,
  orc,
}:

flutter327.buildFlutterApplication rec {
  pname = "pied";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Elleo";
    repo = "pied";
    rev = "refs/tags/v${version}";
    hash = "sha256-I2p3GIb54r9r/phbKJsz/cFw1ECdwZ2RnCYVxjsHzg0=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    libunwind
    gst_all_1.gstreamermm
    orc
  ];

  postInstall = ''
    install -D flatpak/com.mikeasoft.pied.desktop -t $out/share/applications
    install -D flatpak/com.mikeasoft.pied.png -t $out/share/pixmaps
  '';

  meta = {
    description = "Pied makes it simple to install and manage text-to-speech Piper voices for use with Speech Dispatcher.";
    homepage = "https://github.com/Elleo/pied";
    changelog = "https://github.com/Elleo/pied/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "pied";
  };
}
