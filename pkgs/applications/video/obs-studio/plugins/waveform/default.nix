{ stdenv
, lib
, fetchFromGitHub
, cmake
, obs-studio
, pkg-config
, fftwFloat
}:

stdenv.mkDerivation rec {
  pname = "waveform";
  version = "1.8.0";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "phandasm";
    repo = "waveform";
    rev = "v${version}";
    sha256 = "sha256-NcBtj+5X9tPH853a6oXzQCBH26hx8Yt17WjP9ryvgmc=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  postFixup = ''
    mkdir -p $out/lib $out/share/obs/obs-plugins
    mv $out/${pname}/bin/64bit $out/lib/obs-plugins
    mv $out/${pname}/data $out/share/obs/obs-plugins/${pname}
    rm -rf $out/${pname}
  '';

  buildInputs = [
    obs-studio
    fftwFloat
  ];

  meta = {
    description = "Audio spectral analysis plugin for OBS";
    homepage = "https://github.com/phandasm/waveform";
    maintainers = with lib.maintainers; [ matthewcroughan ];
    license = lib.licenses.gpl3;
    platforms = ["x86_64-linux"];
  };
}
