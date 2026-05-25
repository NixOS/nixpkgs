{
  stdenv,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "mlxbf-bootctl";
  version = "unstable-2025-01-16";

  src = fetchFromGitHub {
    owner = "Mellanox";
    repo = "mlxbf-bootctl";
    rev = "278160ca8e08251cff5e7989e5a1010bd247a6ae";
    hash = "sha256-qS35wCb8zvuF2Zs/5hPZkoZAapr7fwKQ/0ZOBPtrkRQ=";
  };

  installPhase = ''
    install -D mlxbf-bootctl $out/bin/mlxbf-bootctl
  '';

  meta = {
    description = "Control BlueField boot partitions";
    homepage = "https://github.com/Mellanox/mlxbf-bootctl";
    license = lib.licenses.bsd2;
    changelog = "https://github.com/Mellanox/mlxbf-bootctl/releases/tag/${pname}-${version}";
    # This package is supposed to only run on a BlueField. Thus aarch64-linux
    # is the only relevant platform.
    platforms = [ "aarch64-linux" ];
    maintainers = with lib.maintainers; [
      nikstur
      thillux
    ];
  };
}
