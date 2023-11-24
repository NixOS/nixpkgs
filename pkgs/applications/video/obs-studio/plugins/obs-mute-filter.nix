{ lib
, stdenv
, fetchFromGitHub
, cmake
, obs-studio
}:

stdenv.mkDerivation rec {
  pname = "obs-mute-filter";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "norihiro";
    repo = "obs-mute-filter";
    rev = version;
    sha256 = "sha256-SiutSmp+DnzMU62kxtBUL0xgMXTe0k+nKwSU3wQe4+g=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  postInstall = ''
    mkdir $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    rm -rf $out/obs-plugins
    mv $out/data $out/share/obs
  '';

  meta = with lib; {
    description = "OBS Studio plugin to mute audio of a source";
    homepage = "https://github.com/norihiro/obs-mute-filter";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
