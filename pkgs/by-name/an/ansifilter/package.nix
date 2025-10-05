{
  fetchurl,
  lib,
  stdenv,
  pkg-config,
  boost,
  lua,
}:

stdenv.mkDerivation rec {
  pname = "ansifilter";
  version = "2.22";

  src = fetchurl {
    url = "http://www.andre-simon.de/zip/ansifilter-${version}.tar.bz2";
    hash = "sha256-zP9BynQLgTv5EDhotQAPQkPTKnUwTqkpohTEm5Q+zJM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost
    lua
  ];

  postPatch = ''
    # avoid timestamp non-determinism with '-n'
    substituteInPlace makefile --replace 'gzip -9f' 'gzip -9nf'
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "conf_dir=/etc/ansifilter"
  ];

  meta = with lib; {
    description = "Tool to convert ANSI to other formats";
    mainProgram = "ansifilter";
    longDescription = ''
      Tool to remove ANSI or convert them to another format
      (HTML, TeX, LaTeX, RTF, Pango or BBCode)
    '';
    homepage = "http://www.andre-simon.de/doku/ansifilter/en/ansifilter.html";
    license = licenses.gpl3;
    maintainers = [ maintainers.Adjective-Object ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
