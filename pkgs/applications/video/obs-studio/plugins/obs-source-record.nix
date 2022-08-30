{ lib, stdenv, fetchFromGitHub, cmake, obs-studio }:

stdenv.mkDerivation rec {
  pname = "obs-source-record";
  version = "unstable-2022-11-10";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-source-record";
    rev = "4a543d3577d56a27f5f2b9aa541a466b37dafde0";
    sha256 = "sha256-LoMgrWZ7r6lu2fisNvqrAiFvxWQQDE6lSxUHkMB/ZPY=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    obs-studio
  ];

  cmakeFlags = [
    "-DBUILD_OUT_OF_TREE=On"
  ];

  postInstall = ''
    rm -rf $out/{data,obs-plugins}
  '';

  meta = with lib; {
    description = "OBS Studio plugin to make sources available to record via a filter";
    homepage = "https://github.com/exeldro/obs-source-record";
    maintainers = with maintainers; [ robbins ];
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
  };
}
