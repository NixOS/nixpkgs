{ lib
, stdenv
, fetchFromGitHub
, libnotify
, makeWrapper
, pass
, wl-clipboard
, wtype
, rofi
, backend ? rofi
}:

stdenv.mkDerivation rec {
  pname = "tessen";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "ayushnix";
    repo = "tessen";
    rev = "v${version}";
    sha256 = "sha256-MkZM/Au0nC2DPkgGDH5XuSJcGfwOtcjFHvMQhKfqSgY=";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -a tessen $out/bin/tessen
  '';

  fixupPhase = let
    wrapperPath = lib.makeBinPath [
      backend
      libnotify
      pass
      wl-clipboard
      wtype
    ];
  in ''
    patchShebangs $out/bin
    wrapProgram $out/bin/tessen --prefix PATH : ${wrapperPath}
  '';

  meta = with lib; {
    homepage = "https://github.com/ayushnix/tessen";
    description = "An interactive menu to autotype and copy pass and gopass data";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ magnouvean ];
  };
}
