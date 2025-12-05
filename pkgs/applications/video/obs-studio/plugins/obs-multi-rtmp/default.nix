{
  lib,
  stdenv,
  fetchFromGitHub,
  obs-studio,
  cmake,
  qtbase,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "obs-multi-rtmp";
  version = "0.6.0.1";

  src = fetchFromGitHub {
    owner = "sorayuki";
    repo = "obs-multi-rtmp";
    rev = version;
    sha256 = "sha256-MRBQY9m6rj8HVdn58mK/Vh07FSm0EglRUaP20P3FFO4=";
  };

  patches = [
    # Fix finding QT. Remove after next release.
    (fetchpatch {
      url = "https://github.com/sorayuki/obs-multi-rtmp/commit/a1289fdef404b08a7acbbf0d6d0f93da4c9fc087.patch";
      hash = "sha256-PDkR315y0iem1+LAqGmiqBFUiMBeEgnFW/xd1W2bAu4=";
      includes = [ "CMakeLists.txt" ];
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    obs-studio
    qtbase
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT" true)
    (lib.cmakeBool "ENABLE_FRONTEND_API" true)
    (lib.cmakeBool "CMAKE_COMPILE_WARNING_AS_ERROR" false)
  ];

  dontWrapQtApps = true;

  # install dirs changed after 0.5.0.3-OBS30
  postInstall = ''
    mkdir -p $out/{lib,share/obs/obs-plugins/}
    mv $out/dist/obs-multi-rtmp/data $out/share/obs/obs-plugins/obs-multi-rtmp
    mv $out/dist/obs-multi-rtmp/bin/64bit $out/lib/obs-plugins
    rm -rf $out/dist
  '';

  meta = {
    homepage = "https://github.com/sorayuki/obs-multi-rtmp/";
    changelog = "https://github.com/sorayuki/obs-multi-rtmp/releases/tag/${version}";
    description = "Multi-site simultaneous broadcast plugin for OBS Studio";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ jk ];
    inherit (obs-studio.meta) platforms;
  };
}
