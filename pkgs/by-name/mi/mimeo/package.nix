{
  lib,
  fetchurl,
  desktop-file-utils,
  file,
  python3Packages,
}:

let
  version = "2023";
in
python3Packages.buildPythonApplication {
  pname = "mimeo";
  inherit version;
  pyproject = true;

  src = fetchurl {
    url = "https://xyne.dev/projects/mimeo/src/mimeo-${version}.tar.xz";
    hash = "sha256-CahvSypwR1aHVDHTdtty1ZfaKBWPolxc73uZ5OyeqZA=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.pyxdg ];

  postPatch = ''
    substituteInPlace Mimeo.py \
      --replace-fail "EXE_UPDATE_DESKTOP_DATABASE = 'update-desktop-database'" \
                     "EXE_UPDATE_DESKTOP_DATABASE = '${desktop-file-utils}/bin/update-desktop-database'" \
      --replace-fail "EXE_FILE = 'file'" \
                     "EXE_FILE = '${file}/bin/file'"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/mimeo --help > /dev/null
  '';

  meta = with lib; {
    description = "Open files by MIME-type or file name using regular expressions";
    homepage = "https://xyne.dev/projects/mimeo/";
    license = [ licenses.gpl2Only ];
    maintainers = [ maintainers.rycee ];
    platforms = platforms.unix;
    mainProgram = "mimeo";
  };
}
