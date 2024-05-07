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

  postInstall = let
    serviceFile = fetchurl {
      url = "https://raw.githubusercontent.com/clash-verge-rev/clash-verge-service/ebd4b31c08a05dd4e7404301f033bba2c4810dfe/src/systemd_service_unit.tmpl";
      hash = "sha256-4w7i4jEV7Fv5TsCKl7skWnhjZeZQ9lfnkKrvPml2ej8=";
    };
  in ''
    install -Dm644 ${serviceFile} $out/lib/systemd/system/clash-verge-service.service
    substituteInPlace $out/lib/systemd/system/clash-verge-service.service \
      --replace "{}" "$out/lib/clash-verge/resources/clash-verge-service"
  '';

  meta = old.meta // (with lib; {
    homepage = "https://github.com/clash-verge-rev/clash-verge-rev";
    maintainers = with maintainers; [ Guanran928 ];
  });
})
