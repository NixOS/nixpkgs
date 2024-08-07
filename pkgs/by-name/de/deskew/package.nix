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

    # Deskew insists on using dlopen to load libtiff, we insist it links against it.
    sed -i -e 's/{$DEFINE DYNAMIC_DLL_LOADING}//' Imaging/LibTiff/LibTiffDynLib.pas
    sed -i -e 's/if LibTiffDynLib\.LoadTiffLibrary then//' Imaging/LibTiff/ImagingTiffLib.pas
    # Make sure libtiff is in the RPATH, so that Nix can find and track the runtime dependency
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath ${lib.getLib libtiff}/lib"
    pushd Scripts && ./compile.sh && popd
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin Bin/deskew
    runHook postInstall
  '';

  meta = with lib; {
    description = "Command line tool for deskewing scanned text documents";
    homepage = "https://galfar.vevb.net/deskew";
    license = with licenses; [ mit mpl11 ];
    maintainers = with maintainers; [ryantm];
    platforms = platforms.all;
    mainProgram = "deskew";
  };

}
