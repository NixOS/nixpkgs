{ lib
, stdenv
, fetchFromGitHub
, cmake
, obs-studio
}:

stdenv.mkDerivation rec {
  pname = "obs-command-source";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "norihiro";
    repo = "obs-command-source";
    rev = version;
    sha256 = "sha256-yrzY4pHSupkkdRlx725oSVtQTH1Ci9zFolHN3i2Vm28=";
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
    description = "OBS Studio plugin that provides a dummy source to execute arbitrary commands when a scene is switched";
    homepage = "https://github.com/norihiro/command-source";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
