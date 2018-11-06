{ stdenv
, buildGoPackage
, fetchFromGitHub
, pkgconfig
, zeromq
, writeText
}:

buildGoPackage rec {
  name = "gophernotes-${version}";
  # necissary for jupyterlab support
  # https://github.com/gopherdata/gophernotes/issues/99
  version = "unstable-b58dd906c43c1ef0b5976b150872c79f82daafcd";
  goPackagePath = "github.com/gopherdata/gophernotes";

  src = fetchFromGitHub {
    owner = "gopherdata";
    repo = "gophernotes";
    rev = "b58dd906c43c1ef0b5976b150872c79f82daafcd";
    sha256 = "1pqa0mjrgbzbrp1zvcl2p4rvb4a5b7mr4k1rdf82rs2h1qkak1d7";
  };

  buildInputs = [ pkgconfig zeromq ];

  goDeps = ./deps.nix;

  # install kernel manually
  postInstall = ''
    mkdir -p $bin/share/jupyter/kernels/gophernotes/
    cp $src/kernel/* $bin/share/jupyter/kernels/gophernotes/
    sed -i "s+gophernotes+$bin/bin/gophernotes+" $bin/share/jupyter/kernels/gophernotes/kernel.json
    cat $bin/share/jupyter/kernels/gophernotes/kernel.json
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/gopherdata/gophernotes;
    description = "The Go kernel for Jupyter notebooks and nteract";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };

}
