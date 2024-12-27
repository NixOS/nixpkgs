{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  curl,
  jq,
  gnugrep,
  libnotify,
  scrot,
  which,
  xclip,
}:

let
  deps = lib.makeBinPath [
    curl
    jq
    gnugrep
    libnotify
    scrot
    which
    xclip
  ];
in
stdenv.mkDerivation rec {
  version = "2.0.0";
  pname = "imgur-screenshot";

  src = fetchFromGitHub {
    owner = "jomo";
    repo = "imgur-screenshot";
    rev = "v${version}";
    sha256 = "0fkhvfraijbrw806pgij41bn1hc3r7l7l3snkicmshxj83lmsd5k";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 imgur-screenshot $out/bin/imgur-screenshot
    wrapProgram $out/bin/imgur-screenshot --prefix PATH ':' ${deps}
  '';

  meta = with lib; {
    description = "Tool for easy screencapping and uploading to imgur";
    homepage = "https://github.com/jomo/imgur-screenshot/";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ lw ];
    mainProgram = "imgur-screenshot";
  };
}
