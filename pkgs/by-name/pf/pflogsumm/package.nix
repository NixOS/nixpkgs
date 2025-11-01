{
  lib,
  fetchurl,
  perlPackages,
}:

perlPackages.buildPerlPackage rec {
  pname = "pflogsumm";
  version = "1.1.3";

  src = fetchurl {
    url = "https://jimsun.linxnet.com/downloads/${pname}-${version}.tar.gz";
    sha256 = "0hkim9s5f1yg5sfs5048jydhy3sbxafls496wcjk0cggxb113py4";
  };

  outputs = [
    "out"
    "man"
  ];
  buildInputs = [ perlPackages.DateCalc ];

  preConfigure = ''
    touch Makefile.PL
  '';
  doCheck = false;

  installPhase = ''
    mkdir -p "$out/bin"
    mv "pflogsumm.pl" "$out/bin/pflogsumm"

    mkdir -p "$out/share/man/man1"
    mv "pflogsumm.1" "$out/share/man/man1"
  '';

  meta = {
    homepage = "http://jimsun.linxnet.com/postfix_contrib.html";
    maintainers = [ ];
    description = "Postfix activity overview";
    mainProgram = "pflogsumm";
    license = lib.licenses.gpl2Plus;
  };
}
