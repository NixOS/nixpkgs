{
  lib,
  flutter329,
  fetchFromGitHub,
  autoPatchelfHook,
  webkitgtk_4_1,
  glib-networking,
  runCommand,
  yq,
  jhentai,
  _experimental-update-script-combinators,
  gitUpdater,
}:

flutter329.buildFlutterApplication rec {
  pname = "jhentai";
  version = "8.0.10+299";

  src = fetchFromGitHub {
    owner = "jiangtian616";
    repo = "JHenTai";
    tag = "v${version}";
    hash = "sha256-gRWYwWKGFeEsBUk4zkGYe8eAnJsf1lk6msEWK9bzk6U=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    desktop_webview_window = "sha256-QDlumlZ3pbmBRkMSJJVgz8HcCdANzV3cU142URvkY1w=";
    dio = "sha256-eHGAV/yIqTaC/wJeSXiPwonPePq+GT1u1dgjbBrW8OI=";
    flutter_draggable_gridview = "sha256-kntjeWEhRl4rdJBO8kt7GCaaLdPWy6b7zmBIjHyP7h8=";
    flutter_slidable = "sha256-nBPEZBvKV3D/eEa/cYb7jgbJ60rbh823yDJALLz1/8c=";
    flutter_socks_proxy = "sha256-a8XZTPTz521o7G7NsEXv2E/H7uVJcY4rcouIkdQC+jg=";
    j_downloader = "sha256-Ct4TZvxKVWirEnSLs+pekDuf+b8tHFUZTdupBflGvJM=";
    like_button = "sha256-OVzfpIEnw88496H345NHn7nZ48+QDTaneBzN2UCdwk8=";
    photo_view = "sha256-k/+ncCzGkF4XmFpo3wmJOQbElSh2r+SlyeI3M9yDFtM=";
    fluttertoast = "sha256-/2VJ1x7l5Idjwkm4Ennz8H/EC3j4/slRODj/82yO3iI=";
    http_proxy = "sha256-/udhj2Tyc7PEtL6eU4TWIdrz/7Uh7D26jDSDxTr3X+I=";
    scrollable_positioned_list = "sha256-8WfyUpTs+Cfv2VzFECrW/DGoKOsu9KY6hf6sP81xuBg=";
    system_network_proxy = "sha256-boPbPO0Xs86Yu4OJmBr/nXGfX/vtZwosP6vRN4g3FQA=";
    zoom_view = "sha256-/JPvmLg8syn5IlKucj3R765kedCZ1LdzkreUIsvdwEg=";
    receive_sharing_intent = "sha256-8D5ZENARPZ7FGrdIErxOoV3Ao35/XoQ2tleegI42ZUY=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    webkitgtk_4_1
    glib-networking
  ];

  flutterBuildFlags = [
    "--target lib/src/main.dart"
  ];

  postInstall = ''
    install -Dm644 linux/assets/top.jtmonster.jhentai.desktop $out/share/applications/jhentai.desktop
    install -Dm644 assets/icon/JHenTai_512.png $out/share/icons/hicolor/512x512/apps/top.jtmonster.jhentai.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/jhentai/lib
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          buildInputs = [ yq ];
          inherit (jhentai) src;
        }
        ''
          cat $src/pubspec.lock | yq > $out
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "jhentai.pubspecSource" ./pubspec.lock.json)
    ];
  };

  meta = {
    description = "Cross-platform manga app made for e-hentai & exhentai by Flutter";
    homepage = "https://github.com/jiangtian616/JHenTai";
    mainProgram = "jhentai";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}
