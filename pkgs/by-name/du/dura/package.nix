{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "dura";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "tkellogg";
    repo = "dura";
    rev = "v${version}";
    sha256 = "sha256-xAcFk7z26l4BYYBEw+MvbG6g33MpPUvnpGvgmcqhpGM=";
  };

  cargoHash = "sha256-Xci9168KqJf+mhx3k0d+nH6Ov5tqNtB6nxiL9BwVYjU=";

  cargoPatches = [
    ./Cargo.lock.patch
  ];

  doCheck = false;

  buildInputs = [
    openssl
    zlib
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {
    description = "Background process that saves uncommitted changes on git";
    mainProgram = "dura";
    longDescription = ''
      Dura is a background process that watches your Git repositories and
      commits your uncommitted changes without impacting HEAD, the current
      branch, or the Git index (staged files). If you ever get into an
      "oh snap!" situation where you think you just lost days of work,
      checkout a "dura" branch and recover.
    '';
    homepage = "https://github.com/tkellogg/dura";
    license = licenses.asl20;
    maintainers = with maintainers; [ drupol ];
  };
}
