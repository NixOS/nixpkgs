{ lib, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "convfont";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "drdnar";
    repo = pname;
    rev = "v20190438";
    sha256 = "1lj24yq5gj9hxhy1srk73521q95zyqzkws0q4v271hf5wmqaxa2f";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    install -Dm755 convfont $out/bin/convfont
  '';

  meta = with lib; {
    description = "Converts font for use with FontLibC";
    homepage = "https://github.com/drdnar/convfont";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.all;
    mainProgram = "convfont";
  };
}
