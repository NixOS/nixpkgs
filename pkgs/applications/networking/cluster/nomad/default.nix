{
  lib,
  buildGo126Module,
  buildGo127Module,
  fetchFromGitHub,
  nixosTests,
  installShellFiles,
}:

let
  generic =
    {
      buildGoModule,
      version,
      hash,
      vendorHash,
      license,
      ...
    }@attrs:
    let
      attrs' = removeAttrs attrs [
        "buildGoModule"
        "version"
        "hash"
        "vendorHash"
        "license"
      ];
    in
    buildGoModule (
      rec {
        pname = "nomad";
        inherit version vendorHash;

        subPackages = [ "." ];

        src = fetchFromGitHub {
          owner = "hashicorp";
          repo = "nomad";
          rev = "v${version}";
          inherit hash;
        };

        nativeBuildInputs = [ installShellFiles ];

        ldflags = [
          "-X github.com/hashicorp/nomad/version.Version=${version}"
          "-X github.com/hashicorp/nomad/version.VersionPrerelease="
          "-X github.com/hashicorp/nomad/version.BuildDate=1970-01-01T00:00:00Z"
        ];

        # ui:
        #  Nomad release commits include the compiled version of the UI, but the file
        #  is only included if we build with the ui tag.
        tags = [ "ui" ];

        postInstall = ''
          echo "complete -C $out/bin/nomad nomad" > nomad.bash
          installShellCompletion nomad.bash
        '';

        meta = {
          homepage = "https://developer.hashicorp.com/nomad";
          description = "Distributed, Highly Available, Datacenter-Aware Scheduler";
          mainProgram = "nomad";
          inherit license;
          maintainers = with lib.maintainers; [
            rushmorem
            techknowlogick
            cottand
          ];
        };
      }
      // attrs'
    );
in
rec {
  # Nomad never updates major go versions within a release series and is unsupported
  # on Go versions that it did not ship with. Due to historic bugs when compiled
  # with different versions we pin Go for all versions.
  # Upstream partially documents used Go versions here
  # https://github.com/hashicorp/nomad/blob/master/contributing/golang.md

  nomad = nomad_2_0;

  nomad_2_1 = generic {
    buildGoModule = buildGo127Module;
    version = "2.1.1";
    hash = "sha256-Cv6fe8AKNuTNAJYmNI6mgxP9NvVzGizZIYbUVVm8Olw=";
    vendorHash = "sha256-d8PfBcwz/7Pi6nRhnKNpRkCDxqXMzw9graSa4AkB76A=";
    license = lib.licenses.bsl11;
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
    __structuredAttrs = true;
  };

  nomad_2_0 = generic {
    buildGoModule = buildGo126Module;
    version = "2.0.0";
    hash = "sha256-5rCAcOXWQ6g2iK1d5wy/a/DZQC2xwwdpI1SscDX98C8=";
    vendorHash = "sha256-3/H7QgVOHtaUs6BOF7ATVgrA0cfNBbm940Axrvq2bKU=";
    license = lib.licenses.bsl11;
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
    __structuredAttrs = true;
  };

  nomad_1_11 = generic {
    buildGoModule = buildGo126Module;
    version = "1.11.3";
    hash = "sha256-J+w53HlMlrXX5yKjDYhf3rSGt1pmOyNcPlOqyUrkLWE=";
    vendorHash = "sha256-67etQUjcPXz4VVpNXLVusQlEybxEqKfYQcNTNL4X8bA=";
    license = lib.licenses.bsl11;
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };

  nomad_1_10 = generic {
    buildGoModule = buildGo126Module;
    version = "1.10.5";
    hash = "sha256-NFH++oYWb6vQN6cOPByscI/ZBWDNy4YbcLiBMO3/jVU=";
    vendorHash = "sha256-QcTw9kKwoHIvXZoxfDohFG+sBs8OLvYPeygygDClsn8=";
    license = lib.licenses.bsl11;
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };
}
