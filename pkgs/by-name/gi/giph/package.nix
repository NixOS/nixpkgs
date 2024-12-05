{ stdenvNoCC
, lib
, fetchFromGitHub
, ffmpeg
, xdotool
, slop
, libnotify
, procps
, makeWrapper
}:

stdenvNoCC.mkDerivation rec {
  pname = "giph";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "phisch";
    repo = pname;
    rev = version;
    sha256 = "19l46m1f32b3bagzrhaqsfnl5n3wbrmg3sdy6fdss4y1yf6nqayk";
  };

  dontConfigure = true;

  dontBuild = true;

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/giph \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg xdotool libnotify slop procps ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/phisch/giph";
    description = "Simple gif recorder";
    license = licenses.mit;
    maintainers = [ maintainers.lom ];
    platforms = platforms.linux;
    mainProgram = "giph";
  };
}
