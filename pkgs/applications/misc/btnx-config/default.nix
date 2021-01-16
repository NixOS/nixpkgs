{ lib, stdenv, fetchFromGitHub, pkgconfig, libdaemon, gtk2 }:

let
  btnx = stdenv.mkDerivation rec {
    pname = "btnx";
    version = "2019-07-11";
    src = fetchFromGitHub {
      owner = "cdobrich";
      repo = pname;
      rev = "ef3f5b9aca798213427831a94ed64ed652438470";
      sha256 = "1a6sl6d403bd049ds1i0hbkc0q6lh34a0hk2i3ms1jcyazca284r";
    };
    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ libdaemon ];
  };
in

stdenv.mkDerivation rec {
  pname = "btnx-config";
  version = "2020-12-28";

  src = fetchFromGitHub {
    owner = "cdobrich";
    repo = pname;
    rev = "bbd99f5990de4a2c0d8ebcf5261867b1b5175ea6";
    sha256 = "1mb8dgghidsdr0nrbr3l0nm4x7lcpxbf07j35bn3kbjgvzlmbsb1";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ btnx gtk2 ];

  meta = with lib; {
    homepage = "https://github.com/cdobrich/btnx-config";
    description = "GUI tool for btnx, daemon that sniffs events from the mouse event handler";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
