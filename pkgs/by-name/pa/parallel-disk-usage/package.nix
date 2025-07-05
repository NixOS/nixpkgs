{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "parallel-disk-usage";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "KSXGitHub";
    repo = "parallel-disk-usage";
    rev = version;
    hash = "sha256-Wj19lWepCrZe36njX+NMdpwXeRRh3ml9jKbbi7irrpg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-UK+jonM/ZBGoCKFcQlCo5OqYtKeU0VIWtx83oBh3lJQ=";

  meta = with lib; {
    description = "Highly parallelized, blazing fast directory tree analyzer";
    homepage = "https://github.com/KSXGitHub/parallel-disk-usage";
    license = licenses.asl20;
    maintainers = [ maintainers.peret ];
    mainProgram = "pdu";
  };
}
