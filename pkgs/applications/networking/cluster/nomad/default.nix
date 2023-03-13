{ lib
, buildGoModule
, buildGo120Module
, fetchFromGitHub
, nixosTests
}:

let
  generic =
    { buildGoModule, version, sha256, vendorSha256, ... }@attrs:
    let attrs' = builtins.removeAttrs attrs [ "buildGoModule" "version" "sha256" "vendorSha256" ];
    in
    buildGoModule (rec {
      pname = "nomad";
      inherit version vendorSha256;

      subPackages = [ "." ];

      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = pname;
        rev = "v${version}";
        inherit sha256;
      };

      # ui:
      #  Nomad release commits include the compiled version of the UI, but the file
      #  is only included if we build with the ui tag.
      tags = [ "ui" ];

      meta = with lib; {
        homepage = "https://www.nomadproject.io/";
        description = "A Distributed, Highly Available, Datacenter-Aware Scheduler";
        platforms = platforms.unix;
        license = licenses.mpl20;
        maintainers = with maintainers; [ rushmorem pradeepchhetri endocrimes maxeaubrey techknowlogick ];
      };
    } // attrs');
in
rec {
  # Nomad never updates major go versions within a release series and is unsupported
  # on Go versions that it did not ship with. Due to historic bugs when compiled
  # with different versions we pin Go for all versions.
  # Upstream partially documents used Go versions here
  # https://github.com/hashicorp/nomad/blob/master/contributing/golang.md

  nomad = nomad_1_4;

  nomad_1_2 = generic {
    buildGoModule = buildGo120Module;
    version = "1.2.16";
    sha256 = "sha256-fhfUpcG91EgIzJ4mCS7geyIJyTSHS2e8t4yYiI3PqpQ=";
    vendorSha256 = "sha256-kwCDsGFw+25Mimgt/cTK/Z2H7Qh5n4rjr3kIBvjcPL8=";
  };

  nomad_1_3 = generic {
    buildGoModule = buildGo120Module;
    version = "1.3.9";
    sha256 = "sha256-xfoIzLDG/OfqAPQqeLvQZ11uESWFNyOyLP6Imi+S96w=";
    vendorSha256 = "sha256-kW0goicoM1lM1NEHPTfozg2EKR1daf33UxT/mVabyfY=";
  };

  nomad_1_4 = generic {
    buildGoModule = buildGo120Module;
    version = "1.4.4";
    sha256 = "sha256-mAimuWolTJ3lMY/ArnLZFu+GZv9ADdGsriXsTcEgdYc=";
    vendorSha256 = "sha256-QtP7pzsIBd2S79AUcbOeVG71Mb5qK706rq5DkT41VqM=";
    passthru.tests.nomad = nixosTests.nomad;
  };
}
