{ stdenv, fetchFromGitHub, qtbase, qtx11extras, qmake, pkgconfig, boost }:

stdenv.mkDerivation rec {
  name = "twmn-git-2018-10-01";

  src = fetchFromGitHub {
    owner = "sboli";
    repo = "twmn";
    rev = "80f48834ef1a07087505b82358308ee2374b6dfb";
    sha256 = "0mpjvp800x07lp9i3hfcc5f4bqj1fj4w3dyr0zwaxc6wqmm0fdqz";
  };

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [ qtbase qtx11extras boost ];

  postPatch = ''
    sed -i s/-Werror// twmnd/twmnd.pro
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp bin/* "$out/bin"

    runHook postInstall
  '';

  meta = {
    description = "A notification system for tiling window managers";
    homepage = https://github.com/sboli/twmn;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = [ stdenv.lib.maintainers.matejc ];
    license = stdenv.lib.licenses.lgpl3;
  };
}
