{ lib
, stdenv
, fetchFromGitHub
, fftwFloat
, chafa
, glib
, libopus
, opusfile
, libvorbis
, taglib
, faad2
, libogg
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "kew";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "ravachol";
    repo = "kew";
    tag = "v${version}";
    hash = "sha256-DzJ+7PanA15A9nIbFPWZ/tdxq4aDyParJORcuqHV7jc=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fftwFloat.dev chafa glib.dev libopus opusfile libvorbis taglib faad2 libogg ];

  installFlags = [
    "MAN_DIR=${placeholder "out"}/share/man"
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Command-line music player for Linux";
    homepage = "https://github.com/ravachol/kew";
    platforms = platforms.unix;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ demine ];
    mainProgram = "kew";
  };
}
