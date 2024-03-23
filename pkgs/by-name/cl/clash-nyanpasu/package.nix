{ lib
, clash-verge
, mihomo
, fetchurl
}:

(clash-verge.override {
  clash-meta = mihomo;
}).overrideAttrs (old: rec {
  pname = "clash-nyanpasu";
  version = "1.4.5";

  src = fetchurl {
    url = "https://github.com/keiko233/clash-nyanpasu/releases/download/v${version}/clash-nyanpasu_${version}_amd64.deb";
    hash = "sha256-cxaq7Rndf0ytEaqc7CGQix5SOAdsTOoTj1Jlhjr5wEA=";
  };

  meta = old.meta // (with lib; {
    homepage = "https://github.com/keiko233/clash-nyanpasu";
    maintainers = with maintainers; [ Guanran928 ];
    mainProgram = "clash-nyanpasu";
  });
})
