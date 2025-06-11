{
  lib,
  flutter329,
  fetchFromGitHub,
  autoPatchelfHook,
}:

flutter329.buildFlutterApplication rec {
  pname = "proxypin";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "wanghongenpin";
    repo = "proxypin";
    tag = "v${version}";
    hash = "sha256-yYZUXgWM7e1+TUvOid1X3WXlAGbUzDHrMXptPXKhuA8=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    desktop_multi_window = "sha256-Tbl0DOxW1F8V2Kj34gcNRbBqr5t9Iq74qCT26deqFdQ=";
    flutter_code_editor = "sha256-w8SbgvfpKbfCr0Y82r/k9pDsZjLOdVJ6D93dzKXct8c=";
  };

  postPatch = ''
    substituteInPlace linux/my_application.cc \
      --replace-fail "/opt/proxypin/data/flutter_assets/assets/icon.png" "$out/app/proxypin/data/flutter_assets/assets/icon.png"
  '';

  nativeBuildInputs = [ autoPatchelfHook ];

  postInstall = ''
    substituteInPlace linux/proxy-pin.desktop \
      --replace-fail "/opt/proxypin/data/flutter_assets/assets/icon.png" "proxypin" \
      --replace-fail "/opt/proxypin/" ""
    install -Dm0644 linux/proxy-pin.desktop $out/share/applications/proxypin.desktop
    install -Dm0644 assets/icon.png $out/share/pixmaps/proxypin.png
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Capture HTTP(S) traffic software";
    homepage = "https://github.com/wanghongenpin/proxypin";
    mainProgram = "ProxyPin";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
