{
  ceph,
  fetchFromGitHub,
  go,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "ceph-csi";
<<<<<<< HEAD
  version = "3.15.1";
=======
  version = "3.15.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ceph";
    repo = "ceph-csi";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-eLF/V6NaBU8r3ttJku4lSGrIuP2vao24rsAsEAWB0wk=";
=======
    hash = "sha256-F9sVFW0KY7PCjeK1RPdvLyO2RMlyROLfpQ49QThrWLY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
