{
  stdenv,
  lib,
  fetchFromGitHub,
  qt6Packages,
  fpc,
  lazarus,
  libx11,
  runCommand,
  python3,
  _7zz,
  brotli,
  upx,
  zpaq,
  zstd,
  writableTmpDirAsHomeHook,
}:

let
  # peazip looks for the "7z", not "7zz"
  _7z = runCommand "7z" { } ''
    mkdir -p $out/bin
    ln -s ${_7zz}/bin/7zz $out/bin/7z
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "peazip";
  version = "11.3.0";

  src = fetchFromGitHub {
    owner = "peazip";
    repo = "peazip";
    rev = finalAttrs.version;
    hash = "sha256-NeFfXFsDYpRHPrIZGkJMvplYxsTw+QzQ33TJzgyDZ+c=";
  };
  sourceRoot = "${finalAttrs.src.name}/peazip-sources";

  # The upstream Pascal source uses CRLF line endings.
  prePatch = ''
    sed -i 's/\r$//' dev/peach.pas
  '';

  patches = [ ./system-backend-default.patch ];

  postPatch = ''
    # set it to use compression programs from $PATH
    substituteInPlace dev/peach.pas --replace-fail "  HSYSBIN       = 0;" "  HSYSBIN       = 2;"
  '';

  nativeBuildInputs = [
    qt6Packages.wrapQtAppsHook
    lazarus
    fpc
    # lazarus tries to create files in $HOME/.lazarus
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    libx11
  ]
  ++ (with qt6Packages; [
    qtbase
    libqtpas
  ]);

  env.NIX_LDFLAGS = "--as-needed -rpath ${lib.makeLibraryPath finalAttrs.buildInputs}";

  buildPhase = ''
    pushd dev
    lazbuild --lazarusdir=${lazarus}/share/lazarus --add-package metadarkstyle/metadarkstyle.lpk
    lazbuild --lazarusdir=${lazarus}/share/lazarus --widgetset=qt6 --build-all project_pea.lpi
    lazbuild --lazarusdir=${lazarus}/share/lazarus --widgetset=qt6 --build-all project_peach.lpi
    popd
  '';

  installPhase = ''
    runHook preInstall

    install -D dev/{pea,peazip} -t $out/lib/peazip
    mkdir -p $out/bin
    makeWrapper $out/lib/peazip/peazip $out/bin/peazip \
      --prefix PATH : ${
        lib.makeBinPath [
          _7z
          brotli
          upx
          zpaq
          zstd
        ]
      } \
      ''${qtWrapperArgs[@]} # putting this here as to not have double wrapping
    makeWrapper $out/lib/peazip/pea $out/bin/pea \
      ''${qtWrapperArgs[@]} # putting this here as to not have double wrapping

    mkdir -p $out/share/peazip $out/lib/peazip/res
    ln -s $out/share/peazip $out/lib/peazip/res/share
    cp -r res/share/{icons,lang,themes,presets} $out/share/peazip/
    # Install desktop entries
    # We don't copy res/share/batch/freedesktop_integration/additional-desktop-files/*.desktop because they are just duplicates of res/share/batch/freedesktop_integration/*.desktop
    install -D res/share/batch/freedesktop_integration/*.desktop -t $out/share/applications
    install -D res/share/batch/freedesktop_integration/KDE-servicemenus/KDE6-dolphin/*.desktop -t $out/share/kio/servicemenus
    install -D res/share/batch/freedesktop_integration/KDE-servicemenus/KDE5-dolphin/*.desktop -t $out/share/kservices5/ServiceMenus
    install -D res/share/batch/freedesktop_integration/KDE-servicemenus/KDE4-dolphin/*.desktop -t $out/share/kde4/services/ServiceMenus
    install -D res/share/batch/freedesktop_integration/KDE-servicemenus/KDE3-konqueror/*.desktop -t $out/share/apps/konqueror/servicemenus

    # Install desktop entries's icons
    for size in {48,256}; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      mkdir $out/share/icons/hicolor/"$size"x"$size"/mimetypes
      mkdir $out/share/icons/hicolor/"$size"x"$size"/actions
    done

    pushd res/share/batch/freedesktop_integration

    cp peazip.png $out/share/icons/hicolor/256x256/apps/
    pushd additional-desktop-files
    cp peazip_{7z,cd,zip}.png $out/share/icons/hicolor/256x256/mimetypes/
    cp peazip_{add,extract,convert}.png $out/share/icons/hicolor/256x256/actions/
    popd

    pushd alternative-icons/48px
    # for some reason the maintainer only made 48px version of *some* icons
    cp peazip.png $out/share/icons/hicolor/48x48/apps/
    cp peazip_{add,extract}.png $out/share/icons/hicolor/48x48/actions/
    popd

    popd

    runHook postInstall
  '';

  dontWrapQtApps = true;

  passthru.tests.system-backends =
    runCommand "peazip-system-backends"
      {
        nativeBuildInputs = [
          python3
          _7zz
          zstd
        ];
        peazip = finalAttrs.finalPackage;
      }
      ''
        python3 <<'PY'
        import os
        from pathlib import Path
        import shutil
        import signal
        import subprocess
        import zipfile

        fixtures = Path("fixtures")
        fixtures.mkdir()
        marker = fixtures / "marker.txt"
        content = b"PeaZip system-backend regression\n"
        marker.write_bytes(content)
        with zipfile.ZipFile(fixtures / "archive.zip", "w", zipfile.ZIP_DEFLATED) as archive:
            archive.writestr(marker.name, content)
        subprocess.run(["7zz", "a", "archive.7z", marker.name], cwd=fixtures, check=True)
        subprocess.run(["zstd", "-q", "-o", str(fixtures / "marker.txt.zst"), str(marker)], check=True)

        seed = None
        for configuration in ["fresh", "truncated"]:
            for archive in ["archive.zip", "archive.7z", "marker.txt.zst"]:
                case = Path(configuration + "-" + archive).resolve()
                case.mkdir()
                shutil.copyfile(fixtures / archive, case / archive)
                environment = os.environ.copy()
                environment.pop("DISPLAY", None)
                environment["QT_QPA_PLATFORM"] = "offscreen"
                for name in ["CONFIG", "CACHE", "DATA", "RUNTIME"]:
                    directory = case / name.lower()
                    directory.mkdir(mode=0o700)
                    environment["XDG_" + name + ("_DIR" if name == "RUNTIME" else "_HOME")] = str(directory)
                config = case / "config" / "peazip" / "conf.txt"
                if configuration == "truncated":
                    config.parent.mkdir()
                    config.write_text(seed.partition("[use system 7z]")[0])
                with (case / "application.log").open("w") as log:
                    process = subprocess.Popen(
                        [os.environ["peazip"] + "/bin/peazip", "-ext2newfolder_", str(case / archive)],
                        cwd=case, env=environment, stdout=log, stderr=subprocess.STDOUT,
                        start_new_session=True,
                    )
                    try:
                        assert process.wait(timeout=20) == 0
                    finally:
                        if process.poll() is None:
                            os.killpg(process.pid, signal.SIGKILL)
                            process.wait()
                extracted = list(case.rglob(marker.name))
                assert len(extracted) == 1 and extracted[0].read_bytes() == content, case
                if seed is None:
                    seed = config.read_text()
                    assert "[use system 7z]" in seed
                print(configuration, archive, "passed", flush=True)
        PY
        touch $out
      '';

  meta = {
    description = "File and archive manager";
    longDescription = ''
      Free Zip / Unzip software and Rar file extractor. File and archive manager.

      Features volume spanning, compression, authenticated encryption.

      Supports 7Z, 7-Zip sfx, ACE, ARJ, Brotli, BZ2, CAB, CHM, CPIO, DEB, GZ, ISO, JAR, LHA/LZH, NSIS, OOo, PEA, RAR, RPM, split, TAR, Z, ZIP, ZIPX, Zstandard.
    '';
    license = lib.licenses.gpl3Only;
    homepage = "https://peazip.github.io";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      annaaurora
      ProxyVT
    ];
    mainProgram = "peazip";
  };
})
