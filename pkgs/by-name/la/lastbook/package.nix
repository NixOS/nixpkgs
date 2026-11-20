{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  python3,
  dpkg,
  makeWrapper,
  wrapGAppsHook3,
  gobject-introspection,
  gtk3,
  webkitgtk_4_1,
  libsoup_3,
  glib-networking,
  gst_all_1,
  pkg-config,
  callPackage,
  withLocalAI ? true,
}:

let
  pythonEnv = python3.withPackages (ps: [
    ps.libzim
    ps.numpy
    ps.beautifulsoup4
    ps.pypdfium2
    ps.pygobject3
  ]);

  # Only for the build: upstream's icon step resizes a PNG with Pillow.
  pythonBuild = python3.withPackages (ps: [ ps.pillow ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lastbook";
  version = "1.1.13";

  src = fetchFromGitHub {
    owner = "Immortal-Protocols";
    repo = "lastbook";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cOBCGXanX9VidOtMTeJMzH+iEHH9iILjnMD6FS5soiQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
    gobject-introspection
    pkg-config
    pythonBuild
  ];

  buildInputs = [
    gtk3
    webkitgtk_4_1
    libsoup_3
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good # MP4 demuxing, WebM
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav # H.264, AAC
    # Many of the library's videos are AV1. gst-plugins-bad's libaom decoder is
    # slow for them; use dav1d as upstream's .deb does, building only that
    # plugin of gst-plugins-rs.
    (gst_all_1.gst-plugins-rs.override { plugins = [ "dav1d" ]; })
  ];

  # In packaged mode the Linux shell drops every GI_TYPELIB*, GST_PLUGIN*,
  # GIO_EXTRA_MODULES, LD_* ... variable before importing GTK, so nothing in the
  # environment can swap in other code. The wrapper passes the store paths of
  # typelibs and plugins through exactly three of those, so keep them.
  postPatch = ''
    substituteInPlace app/shell_linux.py \
      --replace-fail \
        "if k not in RENDERING_SWITCHES and k.startswith(" \
        "if k not in RENDERING_SWITCHES and k not in ('GI_TYPELIB_PATH', 'GST_PLUGIN_SYSTEM_PATH_1_0', 'GIO_EXTRA_MODULES') and k.startswith("
  '';

  dontWrapGApps = true;

  buildPhase = ''
    runHook preBuild

    # web/ and content/ as an app build ships them
    python3 -I -B packaging/ship_app_files.py ship

    # lastbooksrc: the GStreamer source element that plays lastbook:// video URLs
    $CC -shared -fPIC -O2 -Wall packaging/linux/gst/lastbooksrc.c \
      -o libgstlastbooksrc.so $(pkg-config --cflags --libs gstreamer-1.0 gstreamer-base-1.0)

    runHook postBuild
  '';

  # The layout of upstream's /opt/lastbook (packaging/linux/build_app_linux.sh)
  installPhase = ''
    runHook preInstall

    opt=$out/share/lastbook
    mkdir -p $opt/app $opt/engine/setup $opt/setup $opt/gst
    cp app/main.py app/bridge.py app/shell_linux.py $opt/app/
    cp server.py retrieval.py assistant.py llm_local.py $opt/
    cp engine/*.py $opt/engine/
    cp engine/setup/*.py engine/setup/roots.pem $opt/engine/setup/
    cp -R ship/web ship/content $opt/
    cp ${finalAttrs.passthru.manifest} $opt/setup/manifest-v1.json
    cp packaging/linux/lastbook.py $opt/
    cp libgstlastbooksrc.so $opt/gst/
    echo ${finalAttrs.version} > $opt/VERSION
  ''
  + lib.optionalString withLocalAI ''
    ln -s ${finalAttrs.passthru.llm}/libexec/lastbook-llm $opt/llm
  ''
  + ''
    install -Dm644 packaging/linux/lastbook.desktop $out/share/applications/lastbook.desktop
    substituteInPlace $out/share/applications/lastbook.desktop \
      --replace-fail "Exec=/usr/bin/lastbook" "Exec=lastbook"

    python3 -I - packaging/icon/tile-1024.png $out/share/icons/hicolor <<'PY'
    import sys
    from pathlib import Path
    from PIL import Image
    src, out = Image.open(sys.argv[1]).convert('RGBA'), Path(sys.argv[2])
    for n in (16, 24, 32, 48, 64, 128, 256, 512):
        d = out / f'{n}x{n}' / 'apps'
        d.mkdir(parents=True, exist_ok=True)
        src.resize((n, n), Image.LANCZOS).save(d / 'lastbook.png', optimize=True)
    PY

    ${pythonEnv.interpreter} -I -m compileall -q -j $NIX_BUILD_CORES $opt

    runHook postInstall
  '';

  # -I as upstream's launcher: PYTHON* variables and the user's site-packages stay out.
  postFixup = ''
    makeWrapper ${pythonEnv.interpreter} $out/bin/lastbook \
      --unset NIX_PYTHONPATH \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "-I -B $out/share/lastbook/lastbook.py"
  '';

  # setup/manifest-v1.json lists the downloadable packs, maps and model with
  # their SHA-256s. Upstream's release pipeline generates it from files that are
  # not in the repository, so take the one this release shipped with. Only the
  # JSON is kept, so the substitute stays available after upstream prunes old
  # .debs. The app still fetches and merges the live manifest during setup.
  passthru.manifest = fetchurl {
    name = "lastbook-${finalAttrs.version}-manifest-v1.json";
    url = "https://downloads.lastbook.org/Lastbook_${finalAttrs.version}_amd64.deb";
    downloadToTemp = true;
    nativeBuildInputs = [ dpkg ];
    postFetch = ''
      dpkg-deb --fsys-tarfile "$downloadedFile" | tar -xO ./opt/lastbook/setup/manifest-v1.json > "$out"
    '';
    hash = "sha256-YAnfGgLexRCEalyLW74BpB1UE+447/NrqPBix0qj5K0=";
  };

  passthru.llm = callPackage ./lastbook-llm.nix {
    lastbookSrc = finalAttrs.src;
    inherit (finalAttrs) version;
  };

  meta = {
    description = "Offline survival library with guides, manuals, videos, maps and an optional local AI";
    homepage = "https://lastbook.org";
    changelog = "https://github.com/Immortal-Protocols/lastbook/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ harvest316 ];
    mainProgram = "lastbook";
    platforms = lib.platforms.linux;
  };
})
