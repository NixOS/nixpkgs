{
  lib,
  fetchFromGitHub,
  rustPlatform,
  unstableGitUpdater,
}:
rustPlatform.buildRustPackage rec {
  pname = "rails-new";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "rails";
    repo = "rails-new";
    tag = "v${version}";
    hash = "sha256-7hEdLu9Koi2K2EFIl530yA+BGZmATFCcBMe3htYb0rs=";
  };

  cargoHash = "sha256-XwEtC5sSw+x53Nu3mxC8puU3Y53PSIxU6H4p5vkAFKU=";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Generate new Rails applications without having to install Ruby";
    homepage = "https://github.com/rails/rails-new";
    license = lib.licenses.mit;
    mainProgram = "rails-new";
    maintainers = with lib.maintainers; [ coat ];
  };
}
