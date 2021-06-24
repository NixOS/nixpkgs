{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, fetchurl
, cmake
, obs-studio
}:

stdenv.mkDerivation rec {
  pname = "obs-move-transition";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-move-transition";
    rev = version;
    sha256 = "0cl6z3cvdjmbisvfcy281pcg6rhxmyfs31rwv7q4x39352rcs1nw";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  cmakeFlags = with lib; [
    "-DLIBOBS_INCLUDE_DIR=${obs-studio.src}/libobs"
    "-Wno-dev"
  ];

  preConfigure = ''
    cp ${obs-studio.src}/cmake/external/FindLibobs.cmake FindLibobs.cmake
  '';

  patches = [ ./rename-obs-move-transition-cmake.patch ];

  postPatch = ''
    substituteInPlace move-source-filter.c --replace '<../UI/obs-frontend-api/obs-frontend-api.h>' '<obs-frontend-api.h>'
    substituteInPlace move-value-filter.c --replace '<../UI/obs-frontend-api/obs-frontend-api.h>' '<obs-frontend-api.h>'
    substituteInPlace move-transition.c --replace '<../UI/obs-frontend-api/obs-frontend-api.h>' '<obs-frontend-api.h>'
    substituteInPlace audio-move.c --replace '<../UI/obs-frontend-api/obs-frontend-api.h>' '<obs-frontend-api.h>'
  '';

  # obs-studio expects the shared object to be located in bin/32bit or bin/64bit
  # https://github.com/obsproject/obs-studio/blob/d60c736cb0ec0491013293c8a483d3a6573165cb/libobs/obs-nix.c#L48
  postInstall = let
    pluginPath = {
      i686-linux = "bin/32bit";
      x86_64-linux = "bin/64bit";
    }.${stdenv.targetPlatform.system} or (throw "Unsupported system: ${stdenv.targetPlatform.system}");
  in ''
    mkdir -p $out/share/obs/obs-plugins/move-transition/${pluginPath}
    ln -s $out/lib/obs-plugins/move-transition.so $out/share/obs/obs-plugins/move-transition/${pluginPath}
  '';

  meta = with lib; {
    description = "Plugin for OBS Studio to move source to a new position during scene transition";
    homepage = "https://github.com/exeldro/obs-move-transition";
    maintainers = with maintainers; [ starcraft66 ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
