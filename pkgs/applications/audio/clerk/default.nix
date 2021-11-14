{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, rofi
, mpc_cli
, perl
, util-linux
, python3Packages
, libnotify
}:

stdenv.mkDerivation {
  pname = "clerk";
  version = "unstable-2016-10-14";

  src = fetchFromGitHub {
    owner = "carnager";
    repo = "clerk";
    rev = "875963bcae095ac1db174627183c76ebe165f787";
    sha256 = "0y045my65hr3hjyx13jrnyg6g3wb41phqb1m7azc4l6vx6r4124b";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3Packages.mpd2 ];

  dontBuild = true;

  strictDeps = true;

  installPhase = ''
    DESTDIR=$out PREFIX=/ make install
    wrapProgram $out/bin/clerk \
      --prefix PATH : "${lib.makeBinPath [ rofi mpc_cli perl util-linux libnotify ]}"
  '';

  meta = with lib; {
    description = "An MPD client built on top of rofi";
    homepage = "https://github.com/carnager/clerk";
    license = licenses.mit;
    maintainers = with maintainers; [ anderspapitto ];
  };
}
