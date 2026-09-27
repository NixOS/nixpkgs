{
  lib,
  rustPlatform,
  fetchFromGitHub,
  sudachidict,
  runCommand,
  sudachi-rs,
  writeScript,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sudachi-rs";
  version = "0.6.11";

  src = fetchFromGitHub {
    owner = "WorksApplications";
    repo = "sudachi.rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UHJSojDJ5EpoXvXj3qIs2s9Kzg7JrPQhi7o6WWF4Y5o=";
  };

  postPatch = ''
    substituteInPlace sudachi/src/config.rs \
      --replace '"resources"' '"${placeholder "out"}/share/resources"'
  '';

  cargoHash = "sha256-qWuFY97qPoKVxWp29ywaMEr2fTc0Y4wDR9LK+40r6QI=";

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
      cli = runCommand "${finalAttrs.pname}-cli-test" { } ''
        mkdir $out
        echo "高輪ゲートウェイ駅" | ${lib.getExe sudachi-rs} > $out/result
      '';
    };
  };

  meta = {
    description = "Japanese morphological analyzer";
    homepage = "https://github.com/WorksApplications/sudachi.rs";
    changelog = "https://github.com/WorksApplications/sudachi.rs/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "sudachi";
  };
})
