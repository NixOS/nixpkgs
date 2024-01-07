{ lib
, fetchFromGitLab
, python3Packages
, wrapGAppsHook4
, gst_all_1
, gobject-introspection
, yt-dlp
, libadwaita
, libsoup_3
, glib-networking
, nix-update-script
}:
python3Packages.buildPythonApplication rec {
  pname = "monophony";
  version = "2.5.1";
  format = "other";

  sourceRoot = "source/source";
  src = fetchFromGitLab {
    owner = "zehkira";
    repo = "monophony";
    rev = "v${version}";
    hash = "sha256-kBFznJcH6UOlzgUnhPSOUBxqqsHzIEpirN63gRYC/u0=";
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
    libsoup_3
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
      # needed for gstreamer https
      --prefix LD_LIBRARY_PATH : "${lib.getLib libsoup_3}/lib"
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
