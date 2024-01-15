{ lib
, rustPlatform
, fetchFromGitHub
, sudachidict
, runCommand
, sudachi-rs
, writeScript
}:

rustPlatform.buildRustPackage rec {
  pname = "sudachi-rs";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "WorksApplications";
    repo = "sudachi.rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-9GXU+YDPuQ+roqQfUE5q17Hl6AopsvGhRPjZ+Ui+n24=";
  };

  postPatch = ''
    substituteInPlace sudachi/src/config.rs \
      --replace '"resources"' '"${placeholder "out"}/share/resources"'
  '';

  cargoHash = "sha256-Ufo3dB2KGDDNiebp7hLhQrUMLsefO8wRpJQDz57Yb8Y=";

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
    description = "A Japanese morphological analyzer";
    homepage = "https://github.com/WorksApplications/sudachi.rs";
    changelog = "https://github.com/WorksApplications/sudachi.rs/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "sudachi";
  };
}
