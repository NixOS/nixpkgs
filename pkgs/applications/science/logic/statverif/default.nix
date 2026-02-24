{
  lib,
  stdenv,
  fetchurl,
  ocaml,
}:

stdenv.mkDerivation rec {
  pname = "statverif";
  version = "1.86pl4";

  src = fetchurl {
    url = "http://prosecco.gforge.inria.fr/personal/bblanche/proverif/proverif${version}.tar.gz";
    sha256 = "163vdcixs764jj8xa08w80qm4kcijf7xj911yp8jvz6pi1q5g13i";
  };

  pf-patch = fetchurl {
    url = "http://markryan.eu/research/statverif/files/proverif-${version}-statverif-2657ab4.patch";
    sha256 = "113jjhi1qkcggbsmbw8fa9ln8vs7vy2r288szks7rn0jjn0wxmbw";
  };

  strictDeps = true;

  nativeBuildInputs = [ ocaml ];

  patchPhase = "patch -p1 < ${pf-patch}";
  buildPhase = "./build";
  installPhase = ''
    mkdir -p $out/bin
    cp ./proverif      $out/bin/statverif
    cp ./proveriftotex $out/bin/statveriftotex
  '';

  meta = {
    description = "Verification of stateful processes (via Proverif)";
    homepage = "https://markryan.eu/research/statverif/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
