{ lib, stdenv, fetchFromGitHub, lv2, fftwFloat, pkg-config }:

stdenv.mkDerivation rec {
  pname = "talentedhack";
  version = "1.86";

  src = fetchFromGitHub {
    owner = "jeremysalwen";
    repo = "talentedhack";
    rev = "v${version}";
    sha256 = "0kwvayalysmk7y49jq0k16al252md8d45z58hphzsksmyz6148bx";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ lv2 fftwFloat ];

  # To avoid name clashes, plugins should be compiled with symbols hidden, except for `lv2_descriptor`:
  preConfigure = ''
    sed -r 's/^CFLAGS.*$/\0 -fvisibility=hidden/' -i Makefile
  '';

  installPhase = ''
    d=$out/lib/lv2/talentedhack.lv2
    mkdir -p $d
    cp *.so *.ttl $d
  '';

  meta = with lib; {
    homepage = "https://github.com/jeremysalwen/TalentedHack";
    description = "LV2 port of Autotalent pitch correction plugin";
    license = licenses.gpl3;
    maintainers = [ maintainers.michalrus ];
    platforms = platforms.linux;
  };
}
