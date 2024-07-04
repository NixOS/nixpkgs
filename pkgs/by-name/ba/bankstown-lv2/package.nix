{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "bankstown-lv2";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "chadmed";
    repo = "bankstown";
    rev = version;
    hash = "sha256-IThXEY+mvT2MCw0PSWU/182xbUafd6dtm6hNjieLlKg=";
  };

  cargoSha256 = "sha256-yRzM4tcYc6mweTpLnnlCeKgP00L2wRgHamtUzK9Kstc=";

  installPhase = ''
    export LIBDIR=$out/lib
    mkdir -p $LIBDIR

    make
    make install
  '';

  meta = with lib; {
    homepage = "https://github.com/chadmed/bankstown";
    description = "Halfway-decent three-stage psychoacoustic bass approximation";
    license = licenses.mit;
    maintainers = with maintainers; [ yuka ];
    platforms = platforms.linux;
  };
}
