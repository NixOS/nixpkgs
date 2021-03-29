{ stdenv
, lib
, fetchFromGitHub
, ffmpeg
, xdotool
, withSlop ? true
, slop
, withNotify ? true
, libnotify
, withPgrep ? true
, procps
}:

stdenv.mkDerivation rec {
  pname = "giph";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "phisch";
    repo = "giph";
    rev = version;
    sha256 = "19l46m1f32b3bagzrhaqsfnl5n3wbrmg3sdy6fdss4y1yf6nqayk";
  };

  postPatch = ''
    substituteInPlace src/giph \
      --replace '=(ffmpeg' '=(${ffmpeg}/bin/ffmpeg' \
      --replace '="$(xdotool' '="$(${xdotool}/bin/xdotool' \
  '' + lib.optionalString withSlop ''
      --replace '=(ffmpeg' '=(${ffmpeg}/bin/ffmpeg' \
  '' + lib.optionalString withNotify ''
      --replace '=(notify-send' '=(${libnotify}/bin/notify-send' \
  '' + lib.optionalString withPgrep ''
      --replace '"$(pgrep' '"$(${procps}/bin/pgrep'
  '';

  buildInputs = [
    ffmpeg
    xdotool
  ]
  ++ lib.optional
    withSlop
    slop
  ++ lib.optional
    withNotify
    libnotify
  ++ lib.optional
    withPgrep
    procps;

  dontConfigure = true;

  dontBuild = true;

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://github.com/phisch/giph";
    description = "Simple gif recorder";
    license = licenses.mit;
    maintainers = [ maintainers.legendofmiracles ];
  };
}
