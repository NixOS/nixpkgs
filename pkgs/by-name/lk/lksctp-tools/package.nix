{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "lksctp-tools";
  version = "1.0.21";

  src = fetchFromGitHub {
    owner = "sctp";
    repo = "lksctp-tools";
    rev = "v${version}";
    hash = "sha256-+vbdNvHuJLYp901QgtBzMejlbzMyr9Z1eXxR3Zy7eAE=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  meta = {
    description = "Linux Kernel Stream Control Transmission Protocol Tools";
    homepage = "https://github.com/sctp/lksctp-tools/wiki";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21
    ]; # library is lgpl21
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Linux Kernel Stream Control Transmission Protocol Tools";
    homepage = "https://github.com/sctp/lksctp-tools/wiki";
    license = with licenses; [
      gpl2Plus
      lgpl21
    ]; # library is lgpl21
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
