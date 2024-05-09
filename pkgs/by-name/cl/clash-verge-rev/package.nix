{ lib
, clash-verge
, fetchurl
}:

clash-verge.overrideAttrs (old: rec {
  pname = "clash-verge-rev";
  version = "1.6.1";

  src = fetchurl {
    url = "https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v${version}/clash-verge_${version}_amd64.deb";
    hash = "sha256-V6W7IJFa8UrbPWPS2tReecZ41oYvAqV4q0NBkkhUHbQ=";
  };

  meta = old.meta // (with lib; {
    homepage = "https://github.com/clash-verge-rev/clash-verge-rev";
    maintainers = with maintainers; [ Guanran928 ];
  });
})
