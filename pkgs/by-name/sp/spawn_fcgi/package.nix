{
  lib,
  stdenv,
  fetchsvn,
  autoconf,
  automake,
}:

stdenv.mkDerivation rec {
  pname = "spawn-fcgi";
  version = "1.6.4";

  src = fetchsvn {
    url = "svn://svn.lighttpd.net/spawn-fcgi/tags/spawn-fcgi-${version}";
    sha256 = "07r6nwbg4881mdgp0hqh80c4x9wb7jg6cgc84ghwhfbd2abc2iq5";
  };

  nativeBuildInputs = [
    automake
    autoconf
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = {
    homepage = "https://redmine.lighttpd.net/projects/spawn-fcgi";
    description = "Provides an interface to external programs that support the FastCGI interface";
    mainProgram = "spawn-fcgi";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = with lib.platforms; unix;
  };
}
