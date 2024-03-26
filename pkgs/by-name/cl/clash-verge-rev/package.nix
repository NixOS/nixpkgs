{ lib
, clash-verge
, fetchurl
}:

clash-verge.overrideAttrs (old: rec {
  pname = "clash-verge-rev";
  version = "1.5.10";

  src = fetchurl {
    url = "https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v${version}/clash-verge_${version}_amd64.deb";
    hash = "sha256-xv6xKAjpHL4eyFEcgiuHZQi3EDhYkzGHAKbcKm4rIGk=";
  };

  meta = old.meta // (with lib; {
    homepage = "https://github.com/clash-verge-rev/clash-verge-rev";
    maintainers = with maintainers; [ Guanran928 ];
  });
})
