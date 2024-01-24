{ lib, stdenv, fetchFromGitHub, obs-studio, cmake, qtbase, ndi }:

stdenv.mkDerivation rec {
  pname = "obs-ndi";
  version = "4.13.0";

  nativeBuildInputs = [ cmake qtbase ];
  buildInputs = [ obs-studio qtbase ndi ];

  src = fetchFromGitHub {
    owner = "Palakis";
    repo = "obs-ndi";
    rev = version;
    sha256 = "sha256-ugAMSTXbbIZ61oWvoggVJ5kZEgp/waEcWt89AISrSdE=";
  };

  patches = [
    ./hardcode-ndi-path.patch
  ];

  postPatch = ''
    # Add path (variable added in hardcode-ndi-path.patch
    sed -i -e s,@NDI@,${ndi},g src/plugin-main.cpp

    # Replace bundled NDI SDK with the upstream version
    # (This fixes soname issues)
    rm -rf lib/ndi
    ln -s ${ndi}/include lib/ndi
  '';

  cmakeFlags = [ "-DENABLE_QT=ON" ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Network A/V plugin for OBS Studio";
    homepage = "https://github.com/Palakis/obs-ndi";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jshcmpbll ];
    platforms = platforms.linux;
    hydraPlatforms = ndi.meta.hydraPlatforms;
  };
}
