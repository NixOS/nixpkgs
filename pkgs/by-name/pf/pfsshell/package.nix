{
  cmake,
  lib,
  stdenv,
  fetchFromGitHub,
  fuse,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation rec {
  version = "1.1.1-unstable-2025-07-13";
  pname = "pfsshell";

  src = fetchFromGitHub {
    owner = "ps2homebrew";
    repo = "pfsshell";
    rev = "8192de3907a05bb1844afcb1ae490179a38d4ed6";
    fetchSubmodules = true;
    hash = "sha256-drQNnCIqwM+Lnix5LewkD2ov8G6Mbu60xVKQKvCFbPY=";
  };

  nativeBuildInputs = [
    fuse
    meson
    ninja
    pkg-config
  ];

  mesonFlags = [ "-Denable_pfsfuse=true" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "PFS (PlayStation File System) shell for POSIX-based systems";
    platforms = platforms.unix;
    license = with licenses; [
      gpl2Only # the pfsshell software itself
      afl20 # APA, PFS, and iomanX libraries which are compiled together with this package
    ];
    maintainers = with maintainers; [ makefu ];
    mainProgram = "pfsshell";
  };
}
