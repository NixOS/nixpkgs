{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "buffrs";
<<<<<<< HEAD
  version = "0.12.1";
=======
  version = "0.12.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "helsing-ai";
    repo = "buffrs";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-wbJFkKiTMQQJfCO1RyELMyW94lGfECDii3zg7cqc71o=";
  };

  cargoHash = "sha256-zPmFDlOLbv/Zp5qVeiHBxVOfma9X7IpRQ+ascHbz+GQ=";
=======
    hash = "sha256-c1QMPFVc9k3hTK7Y1aimXbJ4IKBNmAt9aYtiUIchG8E=";
  };

  cargoHash = "sha256-6592v/ednZDaKfMcaMCAmJOh4ZhZdBwIpEZiqsbF4hU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Disabling tests meant to work over the network, as they will fail
  # inside the builder.
  checkFlags = [
    "--skip=cmd::install::upgrade::fixture"
    "--skip=cmd::publish::lib::fixture"
    "--skip=cmd::publish::local::fixture"
    "--skip=cmd::tuto::fixture"
  ];

  meta = {
    description = "Modern protobuf package management";
    homepage = "https://github.com/helsing-ai/buffrs";
    license = lib.licenses.asl20;
    mainProgram = "buffrs";
    maintainers = with lib.maintainers; [ danilobuerger ];
  };
}
