{ lib, stdenv, fetchFromGitHub , cairomm, cmake, libjack2, libpthreadstubs, libXdmcp, libxshmfence, libsndfile, lv2, ntk, pkg-config }:

stdenv.mkDerivation rec {
  pname = "artyFX";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "openAVproductions";
    repo = "openAV-ArtyFX";
    rev = "release-${version}";
    hash = "sha256-GD9nwXdXSJX5OvAMxEAnngkvRW+E1jrNfWXK122bsTM=";
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
