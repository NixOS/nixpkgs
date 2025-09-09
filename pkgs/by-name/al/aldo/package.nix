{
  lib,
  stdenv,
  fetchgit,
  libao,
  autoreconfHook,
}:

let
  pname = "aldo";
  version = "0.7.8";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchgit {
    url = "git://git.savannah.gnu.org/${pname}.git";
    tag = "v${version}";
    hash = "sha256-UXzElN8aeDS8E25/JXj2EjM1U1bB3okB8boGfgFum2s=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libao ];

  meta = with lib; {
    description = "Morse code training program";
    homepage = "http://aldo.nongnu.org/";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "aldo";
  };
}
