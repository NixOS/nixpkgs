{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "nsync";
  version = "1.29.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = version;
    hash = "sha256-RAwrS8Vz5fZwZRvF4OQfn8Ls11S8OIV2TmJpNrBE4MI=";
  };

  nativeBuildInputs = [ cmake ];

  # Needed for case-insensitive filesystems like on macOS
  # because a file named BUILD exists already.
  cmakeBuildDir = "build_dir";

  meta = with lib; {
    homepage = "https://github.com/google/nsync";
    description = "C library that exports various synchronization primitives";
    license = licenses.asl20;
    maintainers = with maintainers; [
      puffnfresh
      Luflosi
    ];
    platforms = platforms.unix;
  };
}
