{
  lib,
  flutter332,
  fetchFromGitHub,
  autoPatchelfHook,
}:

flutter332.buildFlutterApplication rec {
  pname = "proxypin";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "wanghongenpin";
    repo = "proxypin";
    tag = "v${version}";
    hash = "sha256-PRknUOCaaDE4Ri70EAROx1K3g2bLKI/HKIvo1W1D8ko=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    desktop_multi_window = "sha256-Tbl0DOxW1F8V2Kj34gcNRbBqr5t9Iq74qCT26deqFdQ=";
    flutter_code_editor = "sha256-B9aJh6e6iLBZAcacucsT9szWWBwWVBBPDhbKQfnxc6I=";
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
    maintainers = with lib.maintainers; [ ];
  };
}
