{
  fetchgit,
  lib,
  ncurses,
  stdenv,
  termcap,
}:

stdenv.mkDerivation rec {
  pname = "readline";
  version = "readline-8.3-alpha";

  src = fetchgit {
    name = "readline";
    url = "https://git.savannah.gnu.org/git/${pname}.git";
    rev = "${version}";
    hash = "sha256-kSP/8hEirW7k8lvfQtkXkTFk46bmxZAFwRwM1xwdcx8=";
  };

  buildInputs = [
    ncurses
    termcap
  ];

  confgureFlags = [
    "--with-curses"
    "--with-shared-termcap-library"
    "--enable-bracketed-paste-default"
    "--enable-install-examples"
    "--enable-multibyte"
    "--enable-shared"
    "--enable-static"
  ];

  meta = {
    description = "Python bindings for the PCRE2 library created by Philip Hazel";
    homepage = "https://github.com/grtetrault/pcre2.py";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tochiaha ];
  };
}
