{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fetchpatch,
  jdk_headless,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "fbjni";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-97KqfFWtR3VJe2s0D60L3dsIDm4kMa0hpkKoZSAEoVY=";
  };

  patches = [
    # Upstram fix for builds on GCC 13. Should be removable with next release after 0.5.1
    (fetchpatch {
      name = "add-cstdint-include.patch";
      url = "https://github.com/facebookincubator/fbjni/commit/59461eff6c7881d58e958287481e1f1cd99e08d3.patch";
      hash = "sha256-r27C+ODTCZdd1tEz3cevnNNyZlrRhq1jOzwnIYlkglM=";
    })

    # Part of https://github.com/facebookincubator/fbjni/pull/76
    # fix cmake file installation directory
    (fetchpatch {
      url = "https://github.com/facebookincubator/fbjni/commit/ab02e60b5da28647bfcc864b0bb1b9a90504cdb1.patch";
      sha256 = "sha256-/h6kosulRH/ZAU2u0zRSaNDK39jsnFt9TaSxyBllZqM=";
    })

    # install headers
    (fetchpatch {
      url = "https://github.com/facebookincubator/fbjni/commit/74e125caa9a815244f1e6bd08eaba57d015378b4.patch";
      sha256 = "sha256-hQS35D69GD3ewV4zzPG+LO7jk7ncCj2CYDbLJ6SnpqE=";
    })
  ];

  nativeBuildInputs = [
    cmake
    jdk_headless
  ];

  buildInputs = [
    gtest
  ];

  cmakeFlags = [
    "-DJAVA_HOME=${jdk_headless.passthru.home}"
  ];

  meta = with lib; {
    description = "Library designed to simplify the usage of the Java Native Interface";
    homepage = "https://github.com/facebookincubator/fbjni";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
