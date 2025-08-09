{
  lib,
  fetchFromGitLab,
  python3Packages,
  wrapGAppsHook4,
  gst_all_1,
  gobject-introspection,
  yt-dlp,
  libadwaita,
  glib-networking,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "monophony";
  version = "3.3.3";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "zehkira";
    repo = "monophony";
    rev = "v${version}";
    hash = "sha256-ET0cygX/r/YXGWpPU01FnBoLRtjo1ddXEiVIva71aE8=";
  };

  sourceRoot = "${src.name}/source";

  dependencies = with python3Packages; [
    mpris-server
    pygobject3
    ytmusicapi
  ];

  build-system = with python3Packages; [
    pip
    setuptools
    wheel
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    # needed for gstreamer https
    glib-networking
  ]
  ++ (with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gstreamer
  ]);

  pythonRelaxDeps = [ "mpris_server" ];

  postInstall = ''
    make install prefix=$out
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ yt-dlp ]}"
      "''${gappsWrapperArgs[@]}"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linux app for streaming music from YouTube";
    longDescription = "Monophony is a free and open source Linux app for streaming music from YouTube. It has no ads and does not require an account.";
    homepage = "https://gitlab.com/zehkira/monophony";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ quadradical ];
    mainProgram = "monophony";
  };
}
