{ stdenv, fetchurl, cmake, lua5 }:

stdenv.mkDerivation {
  name = "task-warrior-2.0.0";

  src = fetchurl {
    url = http://www.taskwarrior.org/download/task-2.0.0.tar.gz;
    sha256 = "1gbmcynj2n2c9dcykxn27ffk034mvm0zri5hqhfdx593dhv1x5vq";
  };

  NIX_LDFLAGS = "-ldl";

  buildNativeInputs = [ cmake ];
  buildInputs = [ lua5 ];

  crossAttrs = {
    preConfigure = ''
      export NIX_CROSS_LDFLAGS="$NIX_CROSS_LDFLAGS -ldl"
    '';
  };

  enableParallelBuilding = true;

  meta = {
    description = "Command-line todo list manager";
    homepage = http://taskwarrior.org/;
    license = "GPLv2+";
  };
}
