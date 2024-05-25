{ stdenv
, lib
, requireFile
, runCommand
, rcu
, testers
, copyDesktopItems
, desktopToDarwinBundle
, libsForQt5
, makeDesktopItem
, python3Packages
, system-config-printer
}:

python3Packages.buildPythonApplication rec {
  pname = "rcu";
  version = "2024.001o";

  format = "other";

  src = let
    src-tarball = requireFile {
      name = "rcu-d${version}-source.tar.gz";
      sha256 = "1smi4cfnwbdil0f77244dfq65i173vb4g3kk451lwh35s91ar628";
      url = "http://www.davisr.me/projects/rcu/";
    };
  in runCommand "${src-tarball.name}-unpacked" {} ''
    gunzip -ck ${src-tarball} | tar -xvf-
    mv rcu $out
  '';

  patches = [
    ./Port-to-paramiko-3.x.patch
  ];

  postPatch = ''
    substituteInPlace src/main.py \
      --replace-fail "ui_basepath = '.'" "ui_basepath = '$out/share/rcu'"

    substituteInPlace package_support/gnulinux/50-remarkable.rules \
      --replace-fail 'GROUP="yourgroup"' 'GROUP="users"'
  '';

  nativeBuildInputs = [
    copyDesktopItems
    libsForQt5.wrapQtAppsHook
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtwayland
  ];

  propagatedBuildInputs = with python3Packages; [
    certifi
    packaging
    paramiko
    pdfminer-six
    pikepdf
    pillow
    protobuf
    pyside2
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "rcu";
      desktopName = "reMarkable Connection Utility";
      comment = "All-in-one offline/local management software for reMarkable e-paper tablets";
      icon = "rcu";
      exec = "rcu";
    })
  ];

  dontConfigure = true;
  dontBuild = true;

  # No tests
  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp -r src $out/share/rcu

  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 package_support/gnulinux/50-remarkable.rules $out/etc/udev/rules.d/50-remarkable.rules
  '' + ''

    # Keep source from being GC'd by linking into it

    for icondir in $(find icons -type d -name '[0-9]*x[0-9]*'); do
      iconsize=$(basename $icondir)
      mkdir -p $out/share/icons/hicolor/$iconsize/apps
      ln -s ${src}/icons/$iconsize/rcu-icon-$iconsize.png $out/share/icons/hicolor/$iconsize/apps/rcu.png
    done

    mkdir -p $out/share/icons/hicolor/scalable/apps
    ln -s ${src}/icons/64x64/rcu-icon-64x64.svg $out/share/icons/hicolor/scalable/apps/rcu.svg

    mkdir -p $out/share/doc/rcu
    for docfile in {COPYING,manual.pdf}; do
      ln -s ${src}/manual/$docfile $out/share/doc/rcu/$docfile
    done

    mkdir -p $out/share/licenses/rcu
    ln -s ${src}/COPYING $out/share/licenses/rcu/COPYING

    runHook postInstall
  '';

  # Manually creating wrapper, hook struggles with lack of shebang & symlink
  dontWrapPythonPrograms = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
      --prefix PATH : ${lib.makeBinPath [ system-config-printer ]}
  '' + ''
    )
  '';

  postFixup = ''
    makeWrapper ${lib.getExe python3Packages.python} $out/bin/rcu \
      ''${makeWrapperArgs[@]} \
      --prefix PYTHONPATH : ${python3Packages.makePythonPath (propagatedBuildInputs ++ [(placeholder "out")])} \
      --add-flags $out/share/rcu/main.py
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = rcu;
      version = let
        versionSuffixPos = (lib.strings.stringLength rcu.version) - 1;
      in
        "d${lib.strings.substring 0 versionSuffixPos rcu.version}(${lib.strings.substring versionSuffixPos 1 rcu.version})";
    };
  };

  meta = with lib; {
    mainProgram = "rcu";
    description = "All-in-one offline/local management software for reMarkable e-paper tablets";
    homepage = "http://www.davisr.me/projects/rcu/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
