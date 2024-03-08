{ stdenv, lib, fetchFromGitHub, cmake, pkg-config
, mpg123, ffmpeg, libvorbis, libao, jansson, speex
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "vgmstream";
  version = "1896";

  src = fetchFromGitHub {
    owner = "vgmstream";
    repo = "vgmstream";
    rev = "refs/tags/r${version}";
    sha256 = "sha256-1BWJgV631MxxzdUtK8f+XRb9cqfhjlwN2LgWI0VmIHE=";
  };

  passthru.updateScript = nix-update-script {
    attrPath = "vgmstream";
    extraArgs = [ "--version-regex" "r(.*)" ];
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ mpg123 ffmpeg libvorbis libao jansson speex ];

  cmakeFlags = [
    # There's no nice way to build the audacious plugin without a circular dependency
    "-DBUILD_AUDACIOUS=OFF"
    # It always tries to download it, no option to use the system one
    "-DUSE_CELT=OFF"
  ];

  meta = with lib; {
    description = "A library for playback of various streamed audio formats used in video games";
    homepage    = "https://vgmstream.org";
    maintainers = with maintainers; [ zane ];
    license     = with licenses; isc;
    platforms   = with platforms; unix;
  };
}
