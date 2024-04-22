{ cmake
, fetchFromGitHub
, pkg-config
, stdenv
, lib
, extra-cmake-modules
# Package dependencies
, libsepol
, seadrive-fuse
, qt5
}:

stdenv.mkDerivation rec {
  pname = "seadrive-gui";
  version = "2.0.16";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seadrive-gui";
    rev = "v${version}";
    sha256 = "0gi2l2knyl0903fslwdhkqlm3p88dznk5nns9lfimbk8as8qd0mf";
  };

  patches = [ ./fix_webkit_webengine.patch ];

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    cmake
    pkg-config
    qt5.qttools
    extra-cmake-modules
  ];
  buildInputs = [
    libsepol
    seadrive-fuse
    qt5.qtwebengine
  ] ++ seadrive-fuse.buildInputs;

  # seadrive-gui calls seadrive-fuse/bin/seadrive at runtime
  # seadrive-fuse implements the actual file syncing,
  # while seadrive-gui is a gui to call and monitor seadrive-fuse
  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ seadrive-fuse ]}"
  ];

  meta = with lib; {
    homepage = "https://github.com/haiwen/seadrive-gui";
    description = "GUI part of Seafile drive";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nayala ];
  };
}
