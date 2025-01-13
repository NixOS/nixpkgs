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
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "WorksApplications";
    repo = "sudachi.rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-G+lJzOYxrR/Le2lgfZMXbbjCqPYmCKMy1pIomTP5NIg=";
  };

  postPatch = ''
    substituteInPlace sudachi/src/config.rs \
      --replace '"resources"' '"${placeholder "out"}/share/resources"'
  '';

  cargoHash = "sha256-iECIk5+QvTP1xiH9AcEJGKt1YHG8KASYmsuIq0vHD20=";

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
