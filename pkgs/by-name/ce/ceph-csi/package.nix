{
  ceph,
  fetchFromGitHub,
  go,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "ceph-csi";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "ceph";
    repo = "ceph-csi";
    rev = "v${version}";
    hash = "sha256-EgHl74kJ6lTS3pqz/Hxh/2tpc1xiDNcJxzERwKops+A=";
  };

  preConfigure = ''
    export GOCACHE=$(pwd)/.cache
  '';

  strictDeps = true;

  nativeBuildInputs = [ go ];

  buildInputs = [ ceph ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ./_output/* $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Container Storage Interface (CSI) driver for Ceph RBD and CephFS";
    downloadPage = "https://github.com/ceph/ceph-csi";
    changelog = "https://github.com/ceph/ceph-csi/releases/tag/v${version}";
    homepage = "https://ceph.com/";
    license = lib.licenses.asl20;
    mainProgram = "cephcsi";
    maintainers = with lib.maintainers; [ johanot ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
