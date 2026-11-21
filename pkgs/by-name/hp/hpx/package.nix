{
  lib,
  stdenv,
  fetchFromGitHub,
  asio,
  boost,
  cmake,
  gperftools,
  hwloc,
  pkg-config,
  python3,
}:

let
  # Keep in sync with HPX_WITH_STDEXEC_TAG in CMakeLists.txt.
  stdexec = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "stdexec";
    rev = "04de75de5807e73a229acf047c6976575e313359";
    hash = "sha256-uknI66hVGD6GOPSnWwXpRaWHQCMNnPKXMv+7e5HjHhs=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hpx";
  version = "2.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "TheHPXProject";
    repo = "hpx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9ot3584DGSbT2Bqp0ejS8KyWzQn0fy1aYHcQ6TP1Bho=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    asio
    boost
    gperftools
  ];

  propagatedBuildInputs = [ hwloc ];

  cmakeFlags = [
    (lib.cmakeBool "HPX_WITH_TESTS" false)
    (lib.cmakeBool "HPX_WITH_EXAMPLES" false)
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_STDEXEC" "${stdexec}")
  ];

  passthru = {
    inherit stdexec;
    updateScript = ./update.sh;
  };

  meta = {
    description = "C++ standard library for concurrency and parallelism";
    homepage = "https://github.com/TheHPXProject/hpx";
    changelog = "https://docs.hpx.dev/latest/html/releases/whats_new_${
      lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }.html";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ iamanaws ];
    platforms = lib.platforms.linux;
  };
})
