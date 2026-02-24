{
  lib,
  bzip2,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,
  zstd,
}:

rustPlatform.buildRustPackage rec {
  pname = "fim-rs";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Achiefs";
    repo = "fim";
    tag = "v${version}";
    hash = "sha256-xJzglrNB5rqaRQTgRFIl8/AXjeDwFPykIE5LJwJ3cX4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # Relies on /var/lib/fim existing, but /var is not available under nix-build.
  doCheck = false;

  meta = {
    description = "Host-based file integrity monitoring tool";
    longDescription = ''
      FIM is a File Integrity Monitoring tool that tracks any event over your
      files. It is capable of keeping historical data of your files. It checks
      the filesystem changes in the background.

      FIM is the fastest alternative to other software like Ossec, which
      performs file integrity monitoring. It could integrate with other
      security tools. The produced data can be ingested and analyzed with
      tools like ElasticSearch/OpenSearch.
    '';
    homepage = "https://github.com/Achiefs/fim";
    changelog = "https://github.com/Achiefs/fim/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "fim";
  };
}
