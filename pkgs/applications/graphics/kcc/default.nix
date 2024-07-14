{ lib
, mkDerivationWith
, python3Packages
, fetchPypi
, p7zip
, archiveSupport ? true
}:

mkDerivationWith python3Packages.buildPythonApplication rec {
  pname = "kcc";
  version = "5.5.1";

  src = fetchPypi {
    inherit version;
    pname = "KindleComicConverter";
    hash = "sha256-Xb7l3F7gagcxauXrryH/oZcAlNuuWYWtc14oB+8RJkQ=";
  };

  propagatedBuildInputs = with python3Packages ; [
    pillow
    pyqt5
    psutil
    python-slugify
    raven
  ];

  qtWrapperArgs = lib.optionals archiveSupport [ "--prefix" "PATH" ":" "${ lib.makeBinPath [ p7zip ] }" ];

  postFixup = ''
    wrapProgram $out/bin/kcc "''${qtWrapperArgs[@]}"
  '';

  meta = with lib; {
    description = "Python app to convert comic/manga files or folders to EPUB, Panel View MOBI or E-Ink optimized CBZ";
    homepage = "https://kcc.iosphe.re";
    license = licenses.isc;
    maintainers = with maintainers; [ dawidsowa ];
  };
}
