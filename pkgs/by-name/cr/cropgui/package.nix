{
  lib,
  python3Packages,
  fetchFromGitea,
  makeWrapper,
  libjpeg,
  exiftool,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cropgui";
  version = "0.9";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "jepler";
    repo = "cropgui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pmo36mWTwDzqE5osXUsM3YzOAPXewLjfrDHIg6hCYjY=";
  };

  pyproject = false;

  nativeBuildInputs = [
    makeWrapper
  ];

  dependencies = with python3Packages; [
    pillow
    tkinter
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${python3Packages.python.sitePackages}
    cp *.py $out/${python3Packages.python.sitePackages}

    install -Dm755 cropgui.desktop $out/share/applications/cropgui.desktop
    install -Dm644 cropgui.png $out/share/icons/hicolor/48x48/apps/cropgui.png

    mkdir -p $out/bin
    makeWrapper $out/${python3Packages.python.sitePackages}/cropgui.py $out/bin/cropgui \
      --prefix PATH : ${
        lib.makeBinPath [
          libjpeg
          exiftool
        ]
      } \
      --prefix PYTHONPATH : "$out/${python3Packages.python.sitePackages}:$PYTHONPATH"

    runHook postInstall
  '';

  meta = {
    description = "Gtk frontend for lossless cropping of jpeg images";
    homepage = "https://codeberg.org/jepler/cropgui";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.dwoffinden ];
    mainProgram = "cropgui";
    platforms = lib.platforms.all;
  };
})
