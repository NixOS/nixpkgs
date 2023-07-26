{ lib
, fetchFromGitHub
, python3
, qt5
, stdenv
, installShellFiles
}:

python3.pkgs.buildPythonApplication rec {
  pname = "vimiv-qt";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "karlch";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pj3gak7nxkw9r9m71zsfvcaq8dk9crbk5rz4n7pravxkl5hs2bg";
  };

  nativeBuildInputs = [ installShellFiles qt5.wrapQtAppsHook python3.pkgs.setuptools ];

  propagatedBuildInputs = with python3.pkgs; [ pyqt5 py3exiv2 ];

  buildInputs = [ qt5.qtsvg ] ++ lib.optionals stdenv.isLinux [ qt5.qtwayland ];

  postInstall = ''
    install -Dm644 misc/vimiv.desktop $out/share/applications/vimiv.desktop
    install -Dm644 misc/org.karlch.vimiv.qt.metainfo.xml $out/metainfo/org.karlch.vimiv.qt.metainfo.xml
    install -Dm644 LICENSE $out/licenses/vimiv/LICENSE
    install -Dm644 icons/vimiv.svg $out/icons/hicolor/scalable/apps/vimiv.svg
    installManPage misc/vimiv.1

    for i in 16 32 64 128 256 512; do
      install -Dm644 icons/vimiv_''${i}x''${i}.png $out/icons/hicolor/''${i}x''${i}/apps/vimiv.png
    done
  '';

  # Vimiv has to be wrapped manually because it is a non-ELF executable.
  dontWrapQtApps = true;
  preFixup = ''
    wrapQtApp $out/bin/vimiv
  '';

  meta = with lib; {
    description = "Image viewer with Vim-like keybindings (Qt port)";
    license = licenses.gpl3Plus;
    homepage = "https://github.com/karlch/vimiv-qt";
    maintainers = with maintainers; [ dschrempf ];
    mainProgram = "vimiv";
    platforms = platforms.all;
  };
}
