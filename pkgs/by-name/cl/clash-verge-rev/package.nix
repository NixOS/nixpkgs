{ lib
, clash-verge
, fetchurl
}:

clash-verge.overrideAttrs (old: rec {
  pname = "clash-verge-rev";
  version = "1.5.8";

  src = fetchurl {
    url = "https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v${version}/clash-verge_${version}_amd64.deb";
    hash = "sha256-cB42pnGgXyIT9H2qTeLAHi37Eij3CrJxgsp4zXRcrx8=";
  };

  meta = old.meta // (with lib; {
    homepage = "https://github.com/clash-verge-rev/clash-verge-rev";
    maintainers = with maintainers; [ Guanran928 ];
  });
})
