{ lib, stdenv, fetchFromGitHub, obs-studio, cmake, qtbase, ndi }:

stdenv.mkDerivation rec {
  pname = "obs-ndi";
  version = "4.10.0";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio qtbase ndi ];

  src = fetchFromGitHub {
    owner = "Palakis";
    repo = "obs-ndi";
    rev = "dummy-tag-${version}";
    sha256 = "sha256-eQ/hQ2AnwyBNOotqlUZq07m4FXoeir2f7cTVq594obc=";
  };

  patches = [
    ./hardcode-ndi-path.patch
  ];

  postPatch = ''
    # Add path (variable added in hardcode-ndi-path.patch)
    sed -i -e s,@NDI@,${ndi},g src/obs-ndi.cpp

    # Replace bundled NDI SDK with the upstream version
    # (This fixes soname issues)
    rm -rf lib/ndi
    ln -s ${ndi}/include lib/ndi
  '';

  postInstall = ''
    mkdir $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    rm -rf $out/obs-plugins
    mv $out/data $out/share/obs
  '';

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
