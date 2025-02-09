{ lib
, rustPlatform
, fetchFromGitHub
, sudachidict
, runCommand
, sudachi-rs
}:

rustPlatform.buildRustPackage rec {
  pname = "sudachi-rs";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "WorksApplications";
    repo = "sudachi.rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-VzNOI6PP9sKBsNfB5yIxAI8jI8TEdM4tD49Jl/2tkSE=";
  };

  postPatch = ''
    substituteInPlace sudachi/src/config.rs \
      --replace '"resources"' '"${placeholder "out"}/share/resources"'
  '';

  cargoHash = "sha256-b2NtgHcMkimzFFuqohAo9KdSaIq6oi3qo/k8/VugyFs=";

  # prepare the resources before the build so that the binary can find sudachidict
  preBuild = ''
    install -Dm644 ${sudachidict}/share/system.dic resources/system.dic
    install -Dm644 resources/* -t $out/share/resources
  '';

  passthru.tests = {
    # detects an error that sudachidict is not found
    cli = runCommand "${pname}-cli-test" { } ''
      mkdir $out
      echo "高輪ゲートウェイ駅" | ${lib.getExe sudachi-rs} > $out/result
    '';
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
