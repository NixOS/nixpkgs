{ lib
, stdenv
, fetchFromGitHub
, fftwFloat
, chafa
, glib
, taglib
, libogg
, faad2
, pkg-config
, opusfile
, libvorbis
}:

stdenv.mkDerivation rec {
  pname = "kew";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "ravachol";
    repo = "kew";
    rev = "v${version}";
    hash = "sha256-w0EenAgAw/7tSmMuAFSaPOdboHj4ox6lqFnAuuprYxE=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libvorbis opusfile taglib libogg faad2 fftwFloat chafa glib ];

  installFlags = [
    "MAN_DIR=${placeholder "out"}/share/man"
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Command-line music player for Linux";
    homepage = "https://github.com/ravachol/kew";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ demine ];
    mainProgram = "kew";
  };
}
