{ lib
, clash-verge
, fetchurl
}:

clash-verge.overrideAttrs (old: rec {
  pname = "clash-verge-rev";
  version = "1.5.11";

  src = fetchurl {
    url = "https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v${version}/clash-verge_${version}_amd64.deb";
    hash = "sha256-FoNWCH4SE7DnKoDMwdUiTnWoFwHSUCAIDQhvgZdgyeU=";
  };

  meta = old.meta // (with lib; {
    homepage = "https://github.com/clash-verge-rev/clash-verge-rev";
    maintainers = with maintainers; [ Guanran928 ];
  });
})
