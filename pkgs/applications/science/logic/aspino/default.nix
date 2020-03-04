{ stdenv, fetchurl, fetchFromGitHub, zlib, boost }:

let
  glucose' = fetchurl {
    url = "http://www.labri.fr/perso/lsimon/downloads/softwares/glucose-syrup.tgz";
    sha256 = "0bq5l2jabhdfhng002qfk0mcj4pfi1v5853x3c7igwfrgx0jmfld";
  };
in

stdenv.mkDerivation {
  name = "aspino-unstable-2017-03-09";

  src = fetchFromGitHub {
    owner = "alviano";
    repo = "aspino";
    rev = "e31c3b4e5791a454e6602439cb26bd98d23c4e78";
    sha256 = "0annsjs2prqmv1lbs0lxr7yclfzh47xg9zyiq6mdxcc02rxsi14f";
  };

  buildInputs = [ zlib boost ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "GCC = g++" "GCC = c++"

    patchShebangs .
  '';

  preBuild = ''
    cp ${glucose'} patches/glucose-syrup.tgz
    ./bootstrap.sh
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m0755 build/release/{aspino,fairino-{bs,ls,ps},maxino-2015-{k16,kdyn}} $out/bin
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "SAT/PseudoBoolean/MaxSat/ASP solver using glucose";
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
    license = licenses.asl20;
    homepage = https://alviano.net/software/maxino/;
    # See pkgs/applications/science/logic/glucose/default.nix
    badPlatforms = [ "aarch64-linux" ];
  };
}
