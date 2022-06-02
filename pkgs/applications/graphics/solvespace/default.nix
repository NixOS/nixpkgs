{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, wrapGAppsHook
, at-spi2-core
, cairo
, dbus
, freetype
, fontconfig
, glew
, gtkmm3
, json_c
, libdatrie
, libepoxy
, libGLU
, libpng
, libselinux
, libsepol
, libthai
, libxkbcommon
, pangomm
, pcre
, util-linuxMinimal # provides libmount
, xorg
, zlib
}:

stdenv.mkDerivation rec {
  pname = "solvespace";
  version = "3.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-aaYqUZ0c1lCL91fmxtKFAAE2uUWrjnDB3WdcqdutXhE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    at-spi2-core
    cairo
    dbus
    freetype
    fontconfig
    glew
    gtkmm3
    json_c
    libdatrie
    libepoxy
    libGLU
    libpng
    libselinux
    libsepol
    libthai
    libxkbcommon
    pangomm
    pcre
    util-linuxMinimal
    xorg.libpthreadstubs
    xorg.libXdmcp
    xorg.libXtst
    zlib
  ];

  postPatch = ''
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

  cmakeFlags = [ "-DENABLE_OPENMP=ON" ];

  meta = with lib; {
    description = "A parametric 3d CAD program";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.edef ];
    platforms = platforms.linux;
    homepage = "https://solvespace.com";
    changelog = "https://github.com/solvespace/solvespace/raw/v${version}/CHANGELOG.md";
  };
}
