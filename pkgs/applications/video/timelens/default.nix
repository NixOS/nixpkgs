{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  glib,
  gst_all_1,
  wrapGAppsHook3,
}:

rustPlatform.buildRustPackage rec {
  pname = "timelens";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "timelens";
    repo = "timelens";
    rev = version;
    hash = "sha256-cGFM1QOuavGwGBccUEttSTp+aD+d31Cqul+AQYvbyhY=";
  };

  cargoHash = "sha256-rVE2foebSEk3zJQTAkmhoIOFyMArGnt9tLlOS7RjQYM=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
  ];

  meta = {
    description = "A open source project for creating visual timelines";
    homepage = "https://timelens.blinry.org";
    changelog = "https://github.com/timelens/timelens/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ janik ];
    mainProgram = "timelens";
  };
}
