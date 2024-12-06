{ lib, stdenv
, fetchgit
}:

stdenv.mkDerivation rec {
  pname = "PStreams";
  version = "1.0.1";

  src = fetchgit {
    url = "https://git.code.sf.net/p/pstreams/code";
    rev = let dot2Underscore = lib.strings.stringAsChars (c: if c == "." then "_" else c);
          in "RELEASE_${dot2Underscore version}";
    sha256 = "0r8aj0nh5mkf8cvnzl8bdy4nm7i74vs83axxfimcd74kjfn0irys";
  };

  makeFlags = [ "prefix=${placeholder "out"}" ];
  dontBuild = true;
  doCheck = true;

  preInstall = "rm INSTALL";
    # `make install` fails on case-insensitive file systems (e.g. APFS by
    # default) because this target exists

  meta = with lib; {
    description = "POSIX Process Control in C++";
    longDescription = ''
      PStreams allows you to run another program from your C++ application and
      to transfer data between the two programs similar to shell pipelines.

      In the simplest case, a PStreams class is like a C++ wrapper for the
      POSIX.2 functions popen(3) and pclose(3), using C++ iostreams instead of
      C's stdio library.
    '';
    homepage = "https://pstreams.sourceforge.net/";
    downloadPage = "https://pstreams.sourceforge.net/download/";
    maintainers = with maintainers; [ arthur ];
    license = licenses.boost;
    platforms = platforms.all;
  };
}
