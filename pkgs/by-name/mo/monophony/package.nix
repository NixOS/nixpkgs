{ lib
, fetchFromGitLab
, python3Packages
, wrapGAppsHook4
, gst_all_1
, gobject-introspection
, yt-dlp
, libadwaita
, glib-networking
, nix-update-script
}:
python3Packages.buildPythonApplication rec {
  pname = "monophony";
  version = "2.8.2";
  format = "other";

  sourceRoot = "${src.name}/source";
  src = fetchFromGitLab {
    owner = "zehkira";
    repo = "monophony";
    rev = "v${version}";
    hash = "sha256-sCJVcf/VAW5UVMwrpri+PPJjQF0s7f2KpmaytuH0jN4=";
  };

  pythonPath = with python3Packages; [
    mpris-server
    pygobject3
    ytmusicapi
  ];

  nativeBuildInputs = [
    python3Packages.nuitka
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    # needed for gstreamer https
    glib-networking
  ] ++ (with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gstreamer
  ]);

  installFlags = [ "prefix=$(out)" ];

  preFixup = ''
    buildPythonPath "$pythonPath"
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$program_PYTHONPATH"
      --prefix PATH : "${lib.makeBinPath [yt-dlp]}"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://gitlab.com/zehkira/monophony";
    description = "Linux app for streaming music from YouTube";
    longDescription = "Monophony is a free and open source Linux app for streaming music from YouTube. It has no ads and does not require an account.";
    license = licenses.agpl3Plus;
    mainProgram = "monophony";
    platforms = platforms.linux;
    maintainers = with maintainers; [ quadradical ];
  };
}
