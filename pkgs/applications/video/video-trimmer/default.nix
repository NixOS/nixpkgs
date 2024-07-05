{ stdenv
, lib
, fetchFromGitLab
, rustPlatform
, cargo
, pkg-config
, meson
, rustc
, wrapGAppsHook4
, desktop-file-utils
, blueprint-compiler
, ninja
, gtk4
, libadwaita
, gst_all_1
, ffmpeg-headless
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "video-trimmer";
  version = "0.8.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "YaLTeR";
    repo = "video-trimmer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nr0PAvp4wlswQBNN2LLyYQMpk3IIleHf3+978XhUGGQ=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-YFbLMpQbHUtxRrBVarcoIeDsvc26NWc1YhMeCaLgJAc=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    wrapGAppsHook4
    desktop-file-utils
    blueprint-compiler
    ninja
    # Present here in addition to buildInputs, because meson runs
    # `gtk4-update-icon-cache` during installPhase, thanks to:
    # https://gitlab.gnome.org/YaLTeR/video-trimmer/-/merge_requests/12
    gtk4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    gtk4
    libadwaita
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good # for scaletempo and webm
    gst_all_1.gst-plugins-bad
  ];

  doCheck = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ ffmpeg-headless ]}"
    )
  '';

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/YaLTeR/video-trimmer";
    description = "Trim videos quickly";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "video-trimmer";
  };
})
