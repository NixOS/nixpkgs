{ lib, stdenv
, fetchFromGitHub
, pkg-config
, xxd
, cairo
, fluidsynth
, libX11
, libjack2
, alsa-lib
, liblo
, libsigcxx
, libsmf
}:

stdenv.mkDerivation rec {
  pname = "mamba";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "Mamba";
    rev = "v${version}";
    sha256 = "sha256-Dj8yPmuEtDVgu6Gm6aEY+dgJ0dtwB8RPg9EuaVAsiIs=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config xxd ];
  buildInputs = [ cairo fluidsynth libX11 libjack2 alsa-lib liblo libsigcxx libsmf ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/brummer10/Mamba";
    description = "Virtual MIDI keyboard for Jack Audio Connection Kit";
    license = licenses.bsd0;
    maintainers = with maintainers; [ magnetophon orivej ];
    platforms = platforms.linux;
    # 2023-08-19, `-Werror=format-security` fails for xputty
    # reported as https://github.com/brummer10/libxputty/issues/12
    broken = true;
  };
}
