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
  format = "setuptools";

  src = fetchurl {
    url = "https://xyne.dev/projects/mimeo/src/mimeo-${version}.tar.xz";
    hash = "sha256-CahvSypwR1aHVDHTdtty1ZfaKBWPolxc73uZ5OyeqZA=";
  };

  buildInputs = [
    file
    desktop-file-utils
  ];

  propagatedBuildInputs = [ python3Packages.pyxdg ];

  preConfigure = ''
    substituteInPlace Mimeo.py \
      --replace "EXE_UPDATE_DESKTOP_DATABASE = 'update-desktop-database'" \
                "EXE_UPDATE_DESKTOP_DATABASE = '${desktop-file-utils}/bin/update-desktop-database'" \
      --replace "EXE_FILE = 'file'" \
                "EXE_FILE = '${file}/bin/file'"
  '';

  installPhase = "install -Dm755 Mimeo.py $out/bin/mimeo";

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
