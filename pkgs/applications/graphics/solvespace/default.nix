{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, zlib, libpng, cairo, freetype
, json_c, fontconfig, gtkmm3, pangomm, glew, libGLU, xorg, pcre, wrapGAppsHook
}:
stdenv.mkDerivation rec {
  pname = "solvespace";
  version = "v3.0";
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "04aympdsjp37vp0p13mb8nwkc080hp9cdrjpyy5m1mhwkm8jm9k9";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config cmake wrapGAppsHook
  ];
  buildInputs = [
    zlib libpng cairo freetype
    json_c fontconfig gtkmm3 pangomm glew libGLU
    xorg.libpthreadstubs xorg.libXdmcp pcre
  ];

  preConfigure = ''
    patch CMakeLists.txt <<EOF
    @@ -20,9 +20,9 @@
     # NOTE TO PACKAGERS: The embedded git commit hash is critical for rapid bug triage when the builds
     # can come from a variety of sources. If you are mirroring the sources or otherwise build when
     # the .git directory is not present, please comment the following line:
    -include(GetGitCommitHash)
    +# include(GetGitCommitHash)
     # and instead uncomment the following, adding the complete git hash of the checkout you are using:
    -# set(GIT_COMMIT_HASH 0000000000000000000000000000000000000000)
    +set(GIT_COMMIT_HASH $version)
    EOF
  '';

  postInstall = ''
    substituteInPlace $out/share/applications/solvespace.desktop \
      --replace /usr/bin/ $out/bin/
  '';

  meta = with lib; {
    description = "A parametric 3d CAD program";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.edef ];
    platforms = platforms.linux;
    homepage = "http://solvespace.com";
  };
}
