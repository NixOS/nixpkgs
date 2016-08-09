{ stdenv, fetchgit, makeWrapper, gettext
, python27, python2Packages
}:

stdenv.mkDerivation rec {
  name    = "metamorphose2-${version}";
  version = "0.9.0beta";

  # exif-py vendored via submodule
  # mutagen vendored via copy
  src = fetchgit {
    url = "https://github.com/metamorphose/metamorphose2.git";
    #rev = "refs/tags/v2.${version}"; #for when wxPython3 support is released
    rev = "d2bdd6a86340b9668e93b35a6a568894c9909d68";
    sha256 = "0ivcb3c8hidrff0ivl4dnwa2p3ihpqjdbvdig8dhg9mm5phdbabn";
  };

  postPatch = ''
    substituteInPlace messages/Makefile \
      --replace "\$(shell which msgfmt)" "${gettext}/bin/msgfmt"
  '';

  postInstall = ''
    rm $out/bin/metamorphose2
    makeWrapper ${python27}/bin/python $out/bin/metamorphose2 \
      --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath "$out") \
      --add-flags "-O $out/share/metamorphose2/metamorphose2.py -w=3"
  '';

  buildInput = [ gettext python27 ];
  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ python2Packages.wxPython python2Packages.pillow ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "a graphical mass renaming program for files and folders";
    homepage    = "https://github.com/metamorphose/metamorphose2";
    license     = with licenses; gpl3Plus;
    maintainer  = with maintainers; [ ramkromberg ];
    platforms   = with platforms; linux;
  };
}
