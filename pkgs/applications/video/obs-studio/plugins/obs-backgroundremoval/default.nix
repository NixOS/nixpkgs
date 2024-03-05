{ lib
, stdenv
, fetchFromGitHub
, cmake
, obs-studio
, onnxruntime
, opencv
}:

stdenv.mkDerivation rec {
  pname = "obs-backgroundremoval";
  version = "0.5.16";

  src = fetchFromGitHub {
    owner = "royshil";
    repo = "obs-backgroundremoval";
    rev = "v${version}";
    hash = "sha256-E+pm/Ma6dZTYlX3DpB49ynTETsRS2TBqgHSCijl/Txc=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio onnxruntime opencv ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DUSE_SYSTEM_ONNXRUNTIME=ON"
    "-DUSE_SYSTEM_OPENCV=ON"
  ];

  postInstall = ''
    mkdir $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    rm -rf $out/obs-plugins
    mv $out/data $out/share/obs
  '';

  meta = with lib; {
    description = "OBS plugin to replace the background in portrait images and video";
    homepage = "https://github.com/royshil/obs-backgroundremoval";
    maintainers = with maintainers; [ zahrun ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
