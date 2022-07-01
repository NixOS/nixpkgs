{ appimageTools, lib, fetchurl }:
let
  pname = "fspy";
  version = "1.0.3";

  src = fetchurl {
    url = "https://github.com/stuffmatic/fSpy/releases/download/v${version}/${pname}-${version}-x86_64.AppImage";
    sha256 = "sha256-L+qsSExuEkzZkjnV/J6rrZ3BXqWQd+IfsN6a3kvQF3A=";
  };

in appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
  '';

  meta = with lib; {
    description = "A cross platform app for quick and easy still image camera matching";
    license = licenses.gpl3;
    homepage = "https://fspy.io/";
    maintainers = with maintainers; [ polygon ];
    platforms = platforms.linux;
    mainProgram = "fspy";
  };
}
