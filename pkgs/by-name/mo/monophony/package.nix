{
  lib,
  fetchFromGitLab,
  python3Packages,
  wrapGAppsHook4,
  gobject-introspection,
  yt-dlp,
  gst_all_1,
  libadwaita,
  glib-networking,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "monophony";
<<<<<<< HEAD
  version = "4.3.0";
=======
  version = "4.1.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitLab {
    owner = "zehkira";
    repo = "monophony";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-w2ev/fpswaNcutxg2zMwrtFkulMbbG7BUm3L8qlnZKk=";
=======
    hash = "sha256-nX4GXuQd+WzaRGBtsWduUpwtA3DGjpRkcxPmoEj7FIA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  sourceRoot = "${src.name}/source";

  dependencies = with python3Packages; [
    mprisify
    requests
    ytmusicapi
<<<<<<< HEAD
    logboth
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  build-system = with python3Packages; [
    setuptools
    pip
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

<<<<<<< HEAD
  postInstall = ''
    make install prefix=$out
  '';
=======
  postInstall = "make install prefix=$out";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
    longDescription = "Monophony allows you to stream and download music from YouTube Music without ads, as well as create and import playlists without signing in.";
    homepage = "https://gitlab.com/zehkira/monophony";
    license = lib.licenses.bsd0;
    platforms = lib.platforms.linux;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
      quadradical
      aleksana
    ];
=======
    maintainers = with lib.maintainers; [ quadradical ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "monophony";
  };
}
