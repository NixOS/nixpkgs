{ lib, stdenv, fetchFromGitHub, makeWrapper, gettext
, python3
}:

stdenv.mkDerivation {
  pname = "metamorphose2";
  version = "0.10.0beta";

  # exif-py vendored via submodule
  src = fetchFromGitHub {
    owner = "timinaust";
    repo = "metamorphose2";
    rev = "ba0666dd02e4f3f58c1dadc309e7ec1cc13fe851";
    sha256 = "0w9l1vyyswdhdwrmi71g23qyslvhg1xym4ksifd42vwf9dxy55qp";
    fetchSubmodules = true;
  };

  postPatch = ''
    rm -rf ./src/mutagen
    substituteInPlace messages/Makefile \
      --replace "\$(shell which msgfmt)" "${gettext}/bin/msgfmt"
  '';

  postInstall = ''
    rm $out/bin/metamorphose2
    makeWrapper ${python3.interpreter} $out/bin/metamorphose2 \
      --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath "$out") \
      --add-flags "-O $out/share/metamorphose2/metamorphose2.py -w=3"
  '';

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = with python3.pkgs; [ mutagen wxpython pillow six ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "a graphical mass renaming program for files and folders";
    homepage    = "https://github.com/timinaust/metamorphose2";
    license     = with licenses; gpl3Plus;
    maintainers = with maintainers; [ ramkromberg ];
    platforms   = with platforms; linux;
  };
}
