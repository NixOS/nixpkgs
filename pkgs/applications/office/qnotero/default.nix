{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  wrapQtAppsHook,
}:

python3Packages.buildPythonPackage rec {
  pname = "qnotero";

  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "ealbiter";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Rym7neluRbYCpuezRQyLc6gSl3xbVR9fvhOxxW5+Nzo=";
  };

  propagatedBuildInputs = [
    python3Packages.pyqt5
    wrapQtAppsHook
  ];

  patchPhase = ''
    substituteInPlace ./setup.py \
      --replace "/usr/share" "usr/share"

    substituteInPlace ./libqnotero/_themes/light.py \
       --replace "/usr/share" "$out/usr/share"
  '';

  preFixup = ''
    wrapQtApp "$out"/bin/qnotero
  '';

  postInstall = ''
    mkdir $out/share
    mv $out/usr/share/applications $out/share/applications

    substituteInPlace $out/share/applications/qnotero.desktop \
      --replace "Icon=/usr/share/qnotero/resources/light/qnotero.png" "Icon=qnotero"

    mkdir -p $out/share/icons/hicolor/64x64/apps
    ln -s $out/usr/share/qnotero/resources/light/qnotero.png \
      $out/share/icons/hicolor/64x64/apps/qnotero.png
  '';

  # no tests executed
  doCheck = false;

  meta = {
    description = "Quick access to Zotero references";
    mainProgram = "qnotero";
    homepage = "https://www.cogsci.nl/software/qnotero";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin; # Build fails even after adding cx-freeze to `buildInputs`
    maintainers = [ lib.maintainers.nico202 ];
  };
}
