{ lib
, fetchFromGitHub
, pkg-config
, python3Packages
, flutter
, gst_all_1
, libunwind
, makeWrapper
, orc
}:

flutter.buildFlutterApplication rec {
  pname = "flet-client-flutter";
  inherit (python3Packages.flet) version;

  sourceRoot = "source/client"; # the flutter code is not on the root of the repo

  src = fetchFromGitHub {
    owner = "flet-dev";
    repo = "flet";
    rev = "v${version}";
    hash = { # avoid stale hashes after a update
      "0.7.4" = "sha256-HUT3+Pvys3VI5oHnCTe2JTUyusq8t2890cj2pbf3e6s=";
    }.${version} or "sha256:${lib.fakeSha256}";
  };

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

  meta = {
    description = "A framework that enables you to easily build realtime web, mobile, and desktop apps in Python. The frontend part.";
    homepage = "https://flet.dev/";
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ heyimnova lucasew ];
    mainProgram = "flet";
  };
}
