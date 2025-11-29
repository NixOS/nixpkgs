{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  boost,
  libbacktrace,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "libsegfault";
  version = "0-unstable-2025-10-01";

  src = fetchFromGitHub {
    owner = "jonathanpoelen";
    repo = "libsegfault";
    rev = "30346f0103d6c301d5be28ec59c57396a9939931";
    sha256 = "AlR5lVo/lQ8RPY2/mlztwhOmWqINU0hHVE6as5D2s8k=";
  };

  env.NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.hostPlatform.isDarwin) "-DBOOST_STACKTRACE_GNU_SOURCE_NOT_REQUIRED=1";

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    boost
    libbacktrace
  ];

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "Implementation of libSegFault.so with Boost.stracktrace";
    homepage = "https://github.com/jonathanpoelen/libsegfault";
    license = licenses.asl20;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
