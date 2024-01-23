{ lib
, buildGoModule
, buildGo120Module
, buildGo121Module
, fetchFromGitHub
, nixosTests
, installShellFiles
}:

let
  generic =
    { buildGoModule, version, sha256, vendorHash, license, ... }@attrs:
    let attrs' = builtins.removeAttrs attrs [ "buildGoModule" "version" "sha256" "vendorHash" "license" ];
    in
    buildGoModule (rec {
      pname = "nomad";
      inherit version vendorHash;

      subPackages = [ "." ];

      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = pname;
        rev = "v${version}";
        inherit sha256;
      };

      nativeBuildInputs = [ installShellFiles ];

      # ui:
      #  Nomad release commits include the compiled version of the UI, but the file
      #  is only included if we build with the ui tag.
      tags = [ "ui" ];

      postInstall = ''
        echo "complete -C $out/bin/nomad nomad" > nomad.bash
        installShellCompletion nomad.bash
      '';

      meta = with lib; {
        homepage = "https://www.nomadproject.io/";
        description = "A Distributed, Highly Available, Datacenter-Aware Scheduler";
        inherit license;
        maintainers = with maintainers; [ rushmorem pradeepchhetri endocrimes amaxine techknowlogick cottand ];
      };
    } // attrs');
in
rec {
  # Nomad never updates major go versions within a release series and is unsupported
  # on Go versions that it did not ship with. Due to historic bugs when compiled
  # with different versions we pin Go for all versions.
  # Upstream partially documents used Go versions here
  # https://github.com/hashicorp/nomad/blob/master/contributing/golang.md

  nomad = nomad_1_6;

  nomad_1_4 = generic {
    buildGoModule = buildGo120Module;
    version = "1.4.12";
    sha256 = "sha256-dO98FOaO5MB5pWzeF705s/aBDTaF0OyWnVxWGB91suI=";
    vendorHash = "sha256-D5TcTZa64Jr47u4mrTXK4lUIC5gfBQNVgL6QKh1CaQM=";
    license = lib.licenses.mpl20;
    passthru.tests.nomad = nixosTests.nomad;
  };

  nomad_1_5 = generic {
    buildGoModule = buildGo121Module;
    version = "1.5.12";
    sha256 = "sha256-BhKetWtwysWTYI0ruEp/Ixh4eoGxDX0Geup2PCXfsZY=";
    vendorHash = "sha256-X4pBxKWr5QFRxh9tw5QDpytyuVNXQvV1LHm5IbPELY0=";
    license = lib.licenses.mpl20;
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };

  nomad_1_6 = generic {
    buildGoModule = buildGo121Module;
    version = "1.6.5";
    sha256 = "sha256-10s/yRWGoYTRbMytWShuTgYc1b388IID5doAvWXpyCU=";
    vendorHash = "sha256-gd6a/CBJ+OOTNHEaRLoDky2f2cDCyW9wSZzD6K22voQ=";
    license = lib.licenses.mpl20;
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };

  nomad_1_7 = generic {
    buildGoModule = buildGo121Module;
    version = "1.7.2";
    sha256 = "sha256-tFmsX9C++nuUBqLjjpMMyVCwQHn4nlB3OywIPMYE32Q=";
    vendorHash = "sha256-iMEEBDxK7ALa19GMIabofzq557aXcYpt0H3/jAKnBBM=";
    license = lib.licenses.bsl11;
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };
}
