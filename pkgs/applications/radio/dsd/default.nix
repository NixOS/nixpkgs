{ lib, stdenv, fetchFromGitHub, cmake
, mbelib, libsndfile, itpp
, portaudioSupport ? true, portaudio ? null
}:

assert portaudioSupport -> portaudio != null;

stdenv.mkDerivation rec {
  pname = "dsd";
  version = "2022-03-14";

  src = fetchFromGitHub {
    owner = "szechyjs";
    repo = "dsd";
    rev = "59423fa46be8b41ef0bd2f3d2b45590600be29f0";
    sha256 = "128gvgkanvh4n5bjnzkfk419hf5fdbad94fb8d8lv67h94vfchyd";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    mbelib libsndfile itpp
  ] ++ lib.optionals portaudioSupport [ portaudio ];

  doCheck = true;

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
