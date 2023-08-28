{ lib
, fetchFromGitHub
, pkg-config
, flutter
, gst_all_1
, libunwind
, makeWrapper
, orc
, nix-update-script
}:

flutter.buildFlutterApplication rec {
  pname = "flet-client-flutter";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "flet-dev";
    repo = "flet";
    rev = "v${version}";
    hash = "sha256-HUT3+Pvys3VI5oHnCTe2JTUyusq8t2890cj2pbf3e6s=";
  };
  sourceRoot = "source/client";

  depsListFile = ./deps.json;
  vendorHash = "sha256-bDH5Bfr1MkNo8ze1D4RAXfMlCklGnsv9bR+1uSnb2Nw=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-vaapi
    gst_all_1.gstreamer
    libunwind
    orc
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A framework that enables you to easily build realtime web, mobile, and desktop apps in Python. The frontend part.";
    homepage = "https://flet.dev/";
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ heyimnova lucasew ];
    mainProgram = "flet";
  };
}
