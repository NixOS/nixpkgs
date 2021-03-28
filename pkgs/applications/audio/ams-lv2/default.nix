{ lib, stdenv, fetchFromGitHub, cairo, fftw, gtkmm2, lv2, lvtk, pkg-config
, wafHook, python3 }:

stdenv.mkDerivation  rec {
  pname = "ams-lv2";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "blablack";
    repo = "ams-lv2";
    rev = version;
    sha256 = "1lz2mvk4gqsyf92yxd3aaldx0d0qi28h4rnnvsaz4ls0ccqm80nk";
  };

  nativeBuildInputs = [ pkg-config wafHook python3 ];
  buildInputs = [ cairo fftw gtkmm2 lv2 lvtk ];

  meta = with lib; {
    description = "An LV2 port of the internal modules found in Alsa Modular Synth";
    homepage = "https://github.com/blablack/ams-lv2";
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
    # Build uses `-msse` and `-mfpmath=sse`
    badPlatforms = [ "aarch64-linux" ];
  };
}
