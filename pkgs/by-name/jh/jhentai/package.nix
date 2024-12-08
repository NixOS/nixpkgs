{
  autoPatchelfHook,
  lib,
  fetchFromGitHub,
  flutter,
  pkg-config,
  webkitgtk_4_1,
}:
flutter.buildFlutterApplication rec {
  pname = "jhentai";
  version = "8.0.5";

  src = fetchFromGitHub {
    owner = "jiangtian616";
    repo = "JHenTai";
    rev = "refs/tags/v${version}";
    hash = "sha256-LL1TyLF37NtwTRN9vhHBY+xHDg0E0ACt2ilacIKpduU=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  postUnpack = ''
    substituteInPlace $sourceRoot/linux/my_application.cc \
      --replace-fail "gtk_widget_realize(GTK_WIDGET(window))" "gtk_widget_show(GTK_WIDGET(window))"
  '';

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
  ];

  buildInputs = [
    webkitgtk_4_1
  ];

  gitHashes = {
    desktop_webview_window = "sha256-QDlumlZ3pbmBRkMSJJVgz8HcCdANzV3cU142URvkY1w=";
    dio = "sha256-eHGAV/yIqTaC/wJeSXiPwonPePq+GT1u1dgjbBrW8OI=";
    flutter_draggable_gridview = "sha256-kntjeWEhRl4rdJBO8kt7GCaaLdPWy6b7zmBIjHyP7h8=";
    flutter_slidable = "sha256-nBPEZBvKV3D/eEa/cYb7jgbJ60rbh823yDJALLz1/8c=";
    flutter_socks_proxy = "sha256-a8XZTPTz521o7G7NsEXv2E/H7uVJcY4rcouIkdQC+jg=";
    flutter_windowmanager = "sha256-+T2w1VLnrkzyvODGmWefa6aN1N+/i4itBgps2zouAas=";
    j_downloader = "sha256-x5RG/SqbfOiRd51dL8H+phLIBrpVdOJiASWhbB5gCNQ=";
    like_button = "sha256-OVzfpIEnw88496H345NHn7nZ48+QDTaneBzN2UCdwk8=";
    photo_view = "sha256-k/+ncCzGkF4XmFpo3wmJOQbElSh2r+SlyeI3M9yDFtM=";
  };

  flutterBuildFlags = [
    "--target lib/src/main.dart"
  ];

  postInstall = ''
    install -Dm644 ./linux/assets/top.jtmonster.jhentai.desktop $out/share/applications/top.jtmonster.jhentai.desktop
    install -Dm644 ./assets/icon_512.png $out/share/icons/hicolor/512x512/apps/top.jtmonster.jhentai.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : "$out/app/${pname}/lib"
  '';

  meta = {
    description = "Cross-platform manga app made for e-hentai & exhentai by Flutter";
    homepage = "https://github.com/jiangtian616/JHenTai";
    mainProgram = "jhentai";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
