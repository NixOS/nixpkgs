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
    { buildGoModule, version, sha256, vendorHash, license, knownVulnerabilities ? [], ... }@attrs:
    let attrs' = builtins.removeAttrs attrs [ "buildGoModule" "version" "sha256" "vendorHash" "license" "knownVulnerabilities" ];
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
        inherit knownVulnerabilities;
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

  nomad = nomad_1_5;

  nomad_1_4 = generic {
    buildGoModule = buildGo120Module;
    version = "1.4.12";
    sha256 = "sha256-dO98FOaO5MB5pWzeF705s/aBDTaF0OyWnVxWGB91suI=";
    vendorHash = "sha256-D5TcTZa64Jr47u4mrTXK4lUIC5gfBQNVgL6QKh1CaQM=";
    license = lib.licenses.mpl20;
    passthru.tests.nomad = nixosTests.nomad;
    knownVulnerabilities = [ "CVE-2024-1329" ];
  };

  nomad_1_5 = generic {
    buildGoModule = buildGo121Module;
    version = "1.5.15";
    sha256 = "sha256-OFmGOU+ObA0+BS48y0ZyyxR+VI5DYL39peVKcyVHgGI=";
    vendorHash = "sha256-Ds94lB43cyMNyRJZti0mZDWGTtSdwY31dDijfAUxR0I=";
    license = lib.licenses.bsl11;
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };

  nomad_1_6 = generic {
    buildGoModule = buildGo121Module;
    version = "1.6.8";
    sha256 = "sha256-lc/HZgyzqWZNW2WHOFZ43gCeL5Y2hwK4lXPgWGboPOY=";
    vendorHash = "sha256-ecLhq4OHDhA1Bd/97NMpfePqtuCtVje3BdvCzcwWzas=";
    license = lib.licenses.bsl11;
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };
}
