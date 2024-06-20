{ lib, stdenv, fetchFromGitHub, blast, tcsh, }:

stdenv.mkDerivation rec {
  pname = "psipred";
  version = "4.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1frxpnrxkhj968k0w6r4npsn5g0jjd0bx6wmb68yqbqkns1qfrgf";
  };

  buildInputs = [ blast tcsh ];

  postPatch = ''
    substituteInPlace ./BLAST+/runpsipredplus \
      --replace "uniref90filt" "\$SEQUENCE_DATA_BANK" \
      --replace "/usr/local/bin" "${blast}/bin" \
      --replace "../bin" "$out/bin" \
      --replace "../data" "$out/share/psipred/data"
  '';

  preBuild = ''
    cd ./src
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 755 psipred psipass2 chkparse seq2mtx ../BLAST+/runpsipredplus -t $out/bin
    install -Dm 755 ../data/* -t $out/share/psipred/data

    runHook postInstall
  '';

  meta = with lib; {
    description = "Protein Secondary Structure Predictor";
    homepage = "http://bioinf.cs.ucl.ac.uk/psipred";
    license = licenses.free;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.linux;
  };
}
