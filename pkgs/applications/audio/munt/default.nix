{ lib
, mkDerivation
, stdenv
, fetchFromGitHub
, makeDesktopItem
, cmake
, pkg-config
, qtbase
, glib
, alsa-lib
, withJack ? stdenv.hostPlatform.isUnix, jack
}:

let
  mainProgram = "mt32emu-qt";
in
mkDerivation rec {
  pname = "munt";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "munt_${lib.replaceChars [ "." ] [ "_" ] version}";
    sha256 = "1lknq2a72gv1ddhzr7f967wpa12lh805jj4gjacdnamgrc1h22yn";
  };

  dontFixCmake = true;

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ qtbase glib ]
    ++ lib.optional stdenv.hostPlatform.isLinux alsa-lib
    ++ lib.optional withJack jack;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/${mainProgram}.app $out/Applications/
    ln -s $out/{Applications/${mainProgram}.app/Contents/MacOS,bin}/${mainProgram}
  '';

  meta = with lib; {
    inherit mainProgram;
    description = "Multi-platform software synthesiser emulating Roland MT-32, CM-32L, CM-64 and LAPC-I devices";
    homepage = "http://munt.sourceforge.net/";
    license = with licenses; [ lgpl21 gpl3 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
