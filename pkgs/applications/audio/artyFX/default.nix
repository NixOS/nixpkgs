{ lib, stdenv, fetchFromGitHub , cairomm, cmake, libjack2, libpthreadstubs, libXdmcp, libxshmfence, libsndfile, lv2, ntk, pkg-config }:

stdenv.mkDerivation rec {
  pname = "artyFX";
  # Fix build with lv2 1.18: https://github.com/openAVproductions/openAV-ArtyFX/pull/41/commits/492587461b50d140455aa3c98d915eb8673bebf0
  version = "unstable-2020-04-28";

  src = fetchFromGitHub {
    owner = "openAVproductions";
    repo = "openAV-ArtyFX";
    rev = "8c542627d936a01b1d97825e7f26a8e95633f7aa";
    sha256 = "0wwg8ivnpyy0235bapjy4g0ij85zq355jwi6c1nkrac79p4z9ail";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ cairomm libjack2 libpthreadstubs libXdmcp libxshmfence libsndfile lv2 ntk ];

  meta = with lib; {
    homepage = "http://openavproductions.com/artyfx/";
    description = "A LV2 plugin bundle of artistic realtime effects";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    # Build uses `-msse` and `-mfpmath=sse`
    badPlatforms = [ "aarch64-linux" ];
  };
}
