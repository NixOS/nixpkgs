{
  lib,
  python3Packages,
  fetchPypi,
  libsForQt5,
  p7zip,
  archiveSupport ? true,
}:

python3Packages.buildPythonApplication rec {
  pname = "kcc";
  version = "5.5.1";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "KindleComicConverter";
    sha256 = "5dbee5dc5ee06a07316ae5ebaf21ffa1970094dbae5985ad735e2807ef112644";
  };

  nativeBuildInputs = [ libsForQt5.wrapQtAppsHook ];

  propagatedBuildInputs = with python3Packages; [
    pillow
    pyqt5
    psutil
    python-slugify
    raven
  ];

  qtWrapperArgs = lib.optionals archiveSupport [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [ p7zip ]}"
  ];

  postFixup = ''
    wrapProgram $out/bin/kcc "''${qtWrapperArgs[@]}"
  '';

  meta = with lib; {
    description = "Python app to convert comic/manga files or folders to EPUB, Panel View MOBI or E-Ink optimized CBZ";
    homepage = "https://github.com/ciromattia/kcc";
    license = licenses.isc;
    maintainers = with maintainers; [ dawidsowa ];
  };
}
