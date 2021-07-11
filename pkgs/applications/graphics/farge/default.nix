{ lib, makeWrapper, fetchFromGitHub, bash, imagemagick, slurp, grim
, wl-clipboard, feh, stdenv, waylandSupport ? true, imageSupport ? true }:

stdenv.mkDerivation rec {
  pname = "farge";
  version = "1.0.8";
  src = fetchFromGitHub {
    owner = "sdushantha";
    repo = "farge";
    rev = "f8fa80f7bebc174ab38efb02292b4d0dec03a7dc";
    sha256 = "08z7dgc3wygl6s922s4gsi2fkrfmghzy82ivnivxr293b9mll7ar";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash imagemagick ]
    ++ lib.optionals waylandSupport [ slurp grim wl-clipboard ]
    ++ lib.optionals imageSupport [ feh ];

  makeFlags = [ "DEST=$(out)/bin" ];
  preInstall = ''
    mkdir -p $out/bin
  '';
  postInstall = ''
    wrapProgram "$out/bin/farge" --prefix PATH : "${lib.makeBinPath buildInputs}"
  '';

  meta = with stdenv.lib; {
    description = "Click on a pixel on your screen and show its color value";
    license = licenses.mit;
    platforms = platforms.unix;
    homepage = "https://github.com/sdushantha/farge";
    maintainers = [ maintainers.loafofpiecrust ];
  };
}
