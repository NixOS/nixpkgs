{ lib
, stdenv
, fetchFromGitLab
, testers
, unstableGitUpdater
, cmake
, boost
, properties-cpp
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "process-cpp";
  version = "unstable-2021-05-11";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "ubports";
    repo = "development/core/lib-cpp/process-cpp";
    rev = "ee6d99a3278343f5fdcec7ed3dad38763e257310";
    hash = "sha256-jDYXKCzrg/ZGFC2xpyfkn/f7J3t0cdOwHK2mLlYWNN0=";
  };

  postPatch = ''
    # Excludes tests from tainting nativeBuildInputs with their dependencies when not being run
    # Tests fail upon verifying OOM score adjustment via /proc/<pid>/oom_score
    # [ RUN      ] LinuxProcess.adjusting_proc_oom_score_adj_works
    # /build/source/tests/linux_process_test.cpp:83: Failure
    # Value of: is_approximately_equal(oom_score.value, core::posix::linux::proc::process::OomScoreAdj::max_value())
    #   Actual: false (333 > 10)
    # Expected: true
    sed -i '/tests/d' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    properties-cpp
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "A simple convenience library for handling processes in C++11";
    homepage = "https://gitlab.com/ubports/development/core/lib-cpp/process-cpp";
    license = with licenses; [ gpl3Only lgpl3Only ];
    maintainers = with maintainers; [ onny OPNA2608 ];
    platforms = platforms.linux;
    pkgConfigModules = [ "process-cpp" ];
  };
})
