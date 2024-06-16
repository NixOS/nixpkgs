{ stdenvNoCC
, fetchurl
, lib
}:

stdenvNoCC.mkDerivation rec {
  pname = "lxgw-wenkai-tc";
  version = "1.330";
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwWenKaiTC/releases/download/v${version}/${pname}-v${version}.tar.gz";
    hash = "sha256-qpX5shH1HbGMa287u/R1rMFgQeAUC0wwKFVD+QSTyho=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    mv *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/lxgw/LxgwWenKaiTC";
    description = "The Traditional Chinese Edition of LXGW WenKai";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ lebensterben ];
  };
}
