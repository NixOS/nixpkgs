{
  lib,
  stdenv,
  fetchgit,
  autoconf,
  automake,
  libtool,
  gmp,
}:

stdenv.mkDerivation rec {
  pname = "git-annex-utils";
  version = "0.04-3-g531bb33";
  src = fetchgit {
    url = "http://git.mysteryvortex.com/repositories/git-annex-utils.git";
    rev = "531bb33";
    sha256 = "1sv7s2ykc840cjwbfn7ayy743643x9i1lvk4cd55w9l052xvzj65";
  };
  nativeBuildInputs = [
    autoconf
    automake
  ];
  buildInputs = [
    libtool
    gmp
  ];
  preConfigure = "./autogen.sh";

  meta = {
    description = "gadu, a du like utility for annexed files";
    longDescription = ''
      This is a set of utilities that are handy to use with git-annex repositories.
      Currently there is only one utility gadu, a du like utility for annexed files.
    '';
    homepage = "https://git-annex.mysteryvortex.com/git-annex-utils.html";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ woffs ];
    mainProgram = "gadu";
    platforms = lib.platforms.all;
  };
}
