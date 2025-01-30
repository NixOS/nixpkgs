{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  jansson,
}:

stdenv.mkDerivation rec {
  pname = "jshon";
  version = "20170302";

  src = fetchFromGitHub {
    owner = "keenerd";
    repo = "jshon";
    rev = "d919aeaece37962251dbe6c1ee50f0028a5c90e4";
    sha256 = "1x4zfmsjq0l2y994bxkhx3mn5vzjxxr39iib213zjchi9h6yxvnc";
  };

  buildInputs = [ jansson ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=strict-prototypes";

  patches = [
    (fetchpatch {
      # https://github.com/keenerd/jshon/pull/62
      url = "https://github.com/keenerd/jshon/commit/96b4e9dbf578be7b31f29740b608aa7b34df3318.patch";
      sha256 = "0kwbn3xb37iqb5y1n8vhzjiwlbg5jmki3f38pzakc24kzc5ksmaa";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile --replace "/usr/" "/"
  '';

  preInstall = ''
    export DESTDIR=$out
  '';

  meta = with lib; {
    homepage = "http://kmkeen.com/jshon";
    description = "JSON parser designed for maximum convenience within the shell";
    mainProgram = "jshon";
    license = licenses.free;
    platforms = platforms.all;
    maintainers = with maintainers; [ rushmorem ];
  };
}
