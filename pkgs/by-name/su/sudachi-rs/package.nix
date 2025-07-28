{
  lib,
  rustPlatform,
  fetchFromGitHub,
  sudachidict,
  runCommand,
  sudachi-rs,
  writeScript,
}:

rustPlatform.buildRustPackage rec {
  pname = "sudachi-rs";
  version = "0.6.10";

  src = fetchFromGitHub {
    owner = "WorksApplications";
    repo = "sudachi.rs";
    tag = "v${version}";
    hash = "sha256-2sJ9diE/EjrQmFcCc4VluE4Gu4RebTYitd7zzfgj3g4=";
  };

  postPatch = ''
    substituteInPlace sudachi/src/config.rs \
      --replace '"resources"' '"${placeholder "out"}/share/resources"'
  '';

  cargoPatches = [
    # https://github.com/WorksApplications/sudachi.rs/issues/299
    ./update-outdated-lockfile.patch
  ];

  cargoHash = "sha256-lUP/9s4W0JehxeCjMmq6G22KMGdDNnq1YlobeLQn2AE=";

  # prepare the resources before the build so that the binary can find sudachidict
  preBuild = ''
    install -Dm644 ${sudachidict}/share/system.dic resources/system.dic
    install -Dm644 resources/* -t $out/share/resources
  '';

  passthru = {
    updateScript = writeScript "update.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update

      set -eu -o pipefail
      nix-update sudachi-rs
      nix-update --version=skip python3Packages.sudachipy
    '';
    tests = {
      # detects an error that sudachidict is not found
      cli = runCommand "${pname}-cli-test" { } ''
        mkdir $out
        echo "高輪ゲートウェイ駅" | ${lib.getExe sudachi-rs} > $out/result
      '';
    };
  };

  meta = with lib; {
    description = "Japanese morphological analyzer";
    homepage = "https://github.com/WorksApplications/sudachi.rs";
    changelog = "https://github.com/WorksApplications/sudachi.rs/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "sudachi";
  };
}
