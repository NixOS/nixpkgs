{stdenv, fetchFromGitHub, python27, htslib, zlib, makeWrapper}:

let python = python27.withPackages (ps: with ps; [ cython ]);

in stdenv.mkDerivation rec {
  name = "platypus-unstable-${version}";
  version = "2017-03-07";

  src = fetchFromGitHub {
    owner = "andyrimmer";
    repo = "Platypus";
    rev = "cbbd914";
    sha256 = "0xgj3pl7n4c12j5pp5qyjfk4rsvb5inwzrpcbhdf3br5f3mmdsb9";
  };

  buildInputs = [ htslib python zlib makeWrapper ];

  buildPhase = ''
    patchShebangs .
    make
  '';

  installPhase = ''
    mkdir -p $out/libexec/platypus
    cp -r ./* $out/libexec/platypus

    mkdir -p $out/bin
    makeWrapper ${python}/bin/python $out/bin/platypus --add-flags "$out/libexec/platypus/bin/Platypus.py"
  '';

  meta = with stdenv.lib; {
    description = "The Platypus variant caller";
    license = licenses.gpl3;
    homepage = https://github.com/andyrimmer/Platypus;
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.x86_64;
  };
}
