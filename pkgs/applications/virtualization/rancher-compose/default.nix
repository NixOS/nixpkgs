{ lib, buildGoPackage, fetchFromGitHub }:

let
  generic = { version, sha256 }: buildGoPackage rec {
    name = "rancher-compose-${version}";

    goPackagePath = "github.com/rancher/rancher-compose";

    src = fetchFromGitHub {
      owner = "rancher";
      repo = "rancher-compose";
      rev = "v${version}";
      inherit sha256;
    };

    buildFlagsArray = ''
      -ldflags=
          -X github.com/rancher/rancher-compose/version.VERSION=${version}
    '';

    excludedPackages = "scripts";

    meta = with lib; {
      description = "Docker compose compatible client to deploy to Rancher";
      homepage = https://docs.rancher.com/rancher/rancher-compose/;
      license = licenses.asl20;
      platforms = platforms.unix;
      maintainers = [maintainers.mic92];
    };
  };
in {
  # should point to a version compatible
  # with the latest stable release of rancher
  rancher-compose = generic {
    version = "0.9.2";
    sha256 = "1wlsdjaa4j2b3c034hb6zci5h900b1msimmshz5h4g5hiaqb3khq";
  };

  # for rancher v1.2.0-pre3+
  rancher-compose_0_10 = generic {
    version = "0.10.0";
    sha256 = "17f3ya4qq0dzk4wvhgxp0lh9p8c87kpq7hmh3g21ashzqwmcflxl";
  };
}
