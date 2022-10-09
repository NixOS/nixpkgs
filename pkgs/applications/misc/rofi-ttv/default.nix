{ stdenv
, lib
, fetchFromGitHub
, makeWrapper

, curl
, jq
, mpv
, rofi-unwrapped
, youtube-dl
}:

stdenv.mkDerivation rec {
  pname = "rofi-ttv";
  version = "20210113";

  src = fetchFromGitHub {
    owner = "loiccoyle";
    repo = pname;
    rev = "e9c722481b740196165f840771b3ae58b7291694";
    sha256 = "sha256-1cvjxulpfOIwipLBa9me4YGLVxSXOAsrFvFq/Q5y0tQ=";
  };

  dontBuild = true;
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    install -vd $out/bin
    install -vm 755 rofi-ttv $out/bin
  '';
  wrapperPath = with lib; makeBinPath [
    curl jq mpv rofi-unwrapped youtube-dl
  ];
  fixupPhase = ''
    patchShebangs $out/bin
    wrapProgram $out/bin/rofi-ttv --prefix PATH : "${wrapperPath}"
  '';

  meta = with lib ; {
    description = "Dynamic menu interface for Twitch";
    homepage = "https://github.com/loiccoyle/rofi-ttv";
    license = licenses.mit;
    maintainers = with maintainers; [ tylerjl ];
  };
}
