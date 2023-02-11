{ lib, stdenv, fetchFromGitHub, libtiff, fpc }:

stdenv.mkDerivation rec {

  pname = "deskew";
  version = "1.30";

  src = fetchFromGitHub {
    owner = "galfar";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xghVOEMkQ/mXpOzJqMaT3SII7xneMNoFqRlqjtzmDnA=";
  };

  nativeBuildInputs = [ fpc ];
  buildInputs = [ libtiff ];

  buildPhase = ''
    runHook preBuild
    patchShebangs ./Scripts
    pushd Scripts && ./compile.sh && popd
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin Bin/deskew
    runHook postInstall
  '';

  meta = with lib; {
    description = "A command line tool for deskewing scanned text documents";
    homepage = "https://galfar.vevb.net/deskew";
    license = with licenses; [ mit mpl11 ];
    maintainers = with maintainers; [ryantm];
    platforms = platforms.all;
  };

}
