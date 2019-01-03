{ stdenv, lib, fetchFromGitHub, rofi, xdotool
, xsel, python3, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "rofimoji";
  version = "unstable-2017-10-31";

  src = fetchFromGitHub {
    owner = "fdw";
    repo = "rofimoji";
    rev = "8c2278b29b0f982936027022cab37e67d0811144";
    sha256 = "18h901i1pqs3n4y3pl3aj5n0j694xlwrxrk742qy0mggh9r4djnc";
  };

  dontBuild = true;

  buildInputs = [ python3 ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -vD rofimoji.py $out/bin/rofimoji
  '';

  postInstall = ''
    wrapProgram $out/bin/rofimoji \
      --prefix PATH : ${lib.makeBinPath [ xdotool xsel ]}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/fdw/rofimoji;
    description = "A simple emoji picker for rofi";
    license = licenses.mit;
    maintainers = with maintainers; [ wedens ];
  };
}
