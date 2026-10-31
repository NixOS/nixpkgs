{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook4,
  gobject-introspection,
  gtk4,
  libadwaita,
  vte-gtk4,
  libsecret,
  sshpass,
  rsync,
}:

python3Packages.buildPythonApplication rec {
  pname = "ashyterm";
  version = "26.10.09-2012";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "big-comm";
    repo = "ashyterm";
    tag = version;
    hash = "sha256-3diHsbFT8ekDseOS+y1L/IBV9bltZfCDYfRlen/zIAg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"uv_build<0.12"' '"uv_build"'
  '';

  build-system = [ python3Packages.uv-build ];

  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    libadwaita
    vte-gtk4
    libsecret
  ];

  dependencies = with python3Packages; [
    asyncssh
    psutil
    py7zr
    pycairo
    pygments
    pygobject3
    regex
    requests
    setproctitle
  ];

  # upstream ships a shell launcher that looks for the code under /usr/lib
  postInstall = ''
    rm -f $out/bin/ashyterm
    mkdir -p $out/bin
    cat > $out/bin/ashyterm <<EOF
    #!${python3Packages.python.interpreter}
    import sys
    from ashyterm import main
    sys.exit(main())
    EOF
    chmod +x $out/bin/ashyterm
  '';

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : ${
        lib.makeBinPath [
          sshpass
          rsync
        ]
      }
    )
  '';

  # most of the suite needs a display or network access, and running it in the
  # sandbox exhausts memory (killed with exit code 137)
  doCheck = false;

  pythonImportsCheck = [ "ashyterm" ];

  meta = {
    description = "GTK4/Adwaita terminal emulator with session management and SSH integration";
    homepage = "https://github.com/big-comm/ashyterm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ igorgbr ];
    mainProgram = "ashyterm";
    platforms = lib.platforms.linux;
  };
}
