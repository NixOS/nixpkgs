{ lib, stdenv, fetchurl
, ncurses
, libX11, xorgproto, buildEnv
, useX11 ? stdenv.hostPlatform.isx86
}:

let
   x11deps = [ libX11 xorgproto ];
   inherit (lib) optionals;

   baseOcamlBranch  = "4.14";
   baseOcamlVersion = "${baseOcamlBranch}.1";
   metaocamlPatch   = "114";
in

stdenv.mkDerivation rec {
  pname = "ber-metaocaml";
  version = metaocamlPatch;

  src = fetchurl {
    url = "https://caml.inria.fr/pub/distrib/ocaml-${baseOcamlBranch}/ocaml-${baseOcamlVersion}.tar.gz";
    sha256 = "sha256-GDl53JwJyw9YCiMraFMaCbAlqmKLjY1ydEnxRv1vX+4=";
  };

  metaocaml = fetchurl {
    url = "http://okmij.org/ftp/ML/ber-metaocaml-${metaocamlPatch}.tar.gz";
    sha256 = "sha256-vvq3xI4jSAsrXcDk97TPbFDYgO9NcQeN/yBcUbcb/y0=";
  };

  x11env = buildEnv { name = "x11env"; paths = x11deps; };
  x11lib = "${x11env}/lib";
  x11inc = "${x11env}/include";

  prefixKey = "-prefix ";
  configureFlags = optionals useX11 [ "--enable-flambda" ];

  dontStrip = true;
  buildInputs = [ ncurses ] ++ optionals useX11 x11deps;

  postConfigure = ''
    tar -xvzf $metaocaml
    cd ${pname}-${version}
    make patch
    cd ..
  '';

  buildPhase = ''
    make world

    make bootstrap
    make opt.opt
    make -i install
    make installopt
    mkdir -p $out/include
    ln -sv $out/lib/ocaml/caml $out/include/caml
    cd ${pname}-${version}
    make all
  '';

  installPhase = ''
    make install
    make install.opt
  '';

  checkPhase = ''
    cd ${pname}-${version}
    make test
    make test-compile
    make test-native
    cd ..
  '';

  passthru = {
    nativeCompilers = true;
  };

  meta = with lib; {
    description     = "Multi-Stage Programming extension for OCaml";
    homepage        = "https://okmij.org/ftp/ML/MetaOCaml.html";
    license         = with licenses; [ /* compiler */ qpl /* library */ lgpl2 ];
    maintainers     = with maintainers; [ thoughtpolice ];

    branch          = baseOcamlBranch;
    platforms       = with platforms; linux ++ darwin;
    broken          = stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isMips;

    longDescription = ''
      A simple extension of OCaml with the primitive type of code values, and
      three basic multi-stage expression forms: Brackets, Escape, and Run.
    '';
  };
}
