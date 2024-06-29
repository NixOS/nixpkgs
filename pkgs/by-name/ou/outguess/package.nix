{ fetchFromGitHub
, stdenv
, lib
, autoconf
, automake
}:

stdenv.mkDerivation rec {
  pname = "outguess";
  version = "0.4";
  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = "outguess";
    rev = version;
    hash = "sha256-yv01jquPTnVk9fd1tqAt1Lxis+ZHZqdG3NiTFxfoXAE=";
  };

  nativeBuildInputs = [ autoconf automake ];

  buildPhase = ''
    ./autogen.sh
    ./configure --with-generic-jconfig --prefix=$out
    make
  '';

  installPhase = ''
    make install
  '';

  meta = with lib; {
    description = "Outguess is a universal steganographic tool that allows the insertion of hidden information into the redundant bits of data sources.";
    homepage = "https://github.com/resurrecting-open-source-projects/outguess";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ HeitorAugustoLN ];
  };
}
