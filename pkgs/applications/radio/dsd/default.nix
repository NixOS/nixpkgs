{ lib, stdenv, fetchFromGitHub, cmake
, mbelib, libsndfile, itpp
, portaudioSupport ? true, portaudio ? null
}:

assert portaudioSupport -> portaudio != null;

stdenv.mkDerivation rec {
  pname = "dsd";
  version = "2018-07-01";

  src = fetchFromGitHub {
    owner = "szechyjs";
    repo = "dsd";
    rev = "f175834e45a1a190171dff4597165b27d6b0157b";
    sha256 = "0w4r13sxvjwacdwxr326zr6p77a8p6ny0g6im574jliw5j3shlhr";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    mbelib libsndfile itpp
  ] ++ lib.optionals portaudioSupport [ portaudio ];

  doCheck = true;
  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD
    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}$PWD
  '';

  meta = with lib; {
    description = "Digital Speech Decoder";
    longDescription = ''
      DSD is able to decode several digital voice formats from discriminator
      tap audio and synthesize the decoded speech. Speech synthesis requires
      mbelib, which is a separate package.
    '';
    homepage = "https://github.com/szechyjs/dsd";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ andrew-d ];
  };
}
