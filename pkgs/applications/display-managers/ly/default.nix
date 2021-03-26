{ stdenv, lib, fetchFromGitHub, linux-pam, git, libxcb, ncurses }:

# This package is intended to be reworked, it is temporarily using a fork since
# the original developer used a non-standard method of specifying .gitmodules.
# https://github.com/nullgemm/ly/pull/279

stdenv.mkDerivation rec {
  pname = "ly";
  version = "unstable-2021-03-25";

  hardeningDisable = [ "all" ];

  nativeBuildInputs = [ git ];

  buildInputs = [ libxcb linux-pam ncurses ];

  src = fetchFromGitHub {
    owner = "matthewcroughan";
    repo = "ly";
    rev = "850c7b1112c44f4b0e9c0837d8b3d0c7fe02821f";
    sha256 = "sha256-XLVfKnxr5GKMN6pRTOIaKW6KMH6hzW8KwboEFtuOkY0=";
    fetchSubmodules = true;
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bin/ly $out/bin
  '';

  meta = with lib; {
    description = "TUI display manager";
    license = licenses.wtfpl;
    homepage = "https://github.com/nullgemm/ly";
    maintainers = with maintainers; [ matthewcroughan nixinator ];
  };
}
