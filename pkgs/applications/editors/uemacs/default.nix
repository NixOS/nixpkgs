{ stdenv, fetchgit, ncurses }:

stdenv.mkDerivation rec {
  name = "uemacs-${version}";
  version = "2014-12-08";

  src = fetchgit {
    url = git://git.kernel.org/pub/scm/editors/uemacs/uemacs.git;
    rev = "8841922689769960fa074fbb053cb8507f2f3ed9";
    sha256 = "14yq7kpkax111cg6k7i3mnqk7sq7a65krq6qizzj7vvnm7bsj3sd";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "-lcurses" "-lncurses" \
      --replace "CFLAGS=-O2" "CFLAGS+=" \
      --replace "BINDIR=/usr/bin" "BINDIR=$out/bin" \
      --replace "LIBDIR=/usr/lib" "LIBDIR=$out/share/uemacs"
    substituteInPlace epath.h \
      --replace "/usr/global/lib/" "$out/share/uemacs/" \
      --replace "/usr/local/bin/" "$out/bin/" \
      --replace "/usr/local/lib/" "$out/share/uemacs/" \
      --replace "/usr/local/" "$out/bin/" \
      --replace "/usr/lib/" "$out/share/uemacs/"
    mkdir -p $out/bin $out/share/uemacs
  '';

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    homepage = https://git.kernel.org/cgit/editors/uemacs/uemacs.git;
    description = "Torvalds Micro-emacs fork";
    longDescription = ''
      uEmacs/PK 4.0 is a full screen editor based on MicroEMACS 3.9e
    '';
    license = licenses.unfree;
  };
}
