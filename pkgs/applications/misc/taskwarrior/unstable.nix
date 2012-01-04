{ stdenv, fetchurl, cmake, lua5 }:

stdenv.mkDerivation {
  name = "task-warrior-2.0.0.beta4";

  src = fetchurl {
    url = http://www.taskwarrior.org/download/task-2.0.0.beta4.tar.gz;
    sha256 = "1c9n6b5ly3m5kminnsvqgmjxdkb68w4av9kdnh47dw4sj3gwrn1w";
  };

  NIX_LDFLAGS = "-ldl";

  buildNativeInputs = [ cmake ];
  buildInputs = [ lua5 ];

  crossAttrs = {
    preConfigure = ''
      export NIX_CROSS_LDFLAGS="$NIX_CROSS_LDFLAGS -ldl"
    '';
  };

  meta = {
    description = "Command-line todo list manager";
    homepage = http://taskwarrior.org/;
    license = "MIT";
  };
}
