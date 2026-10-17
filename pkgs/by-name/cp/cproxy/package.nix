{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cproxy";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "NOBLES5E";
    repo = "cproxy";
    tag = "v${version}";
    hash = "sha256-WU2goAiTPE8cTK3dDSX+RHvVBoY5QMBTZc1bu8ZOQn8=";
  };

  cargoHash = "sha256-MTBaraHZ60QhgaQn95pmFb23nC6D+KLWAmS186qyaFg=";
  useFetchCargoVendor = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Easy per application transparent proxy built on cgroup";
    homepage = "https://github.com/NOBLES5E/cproxy";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "cproxy";
    platforms = lib.platforms.linux;
  };
}
