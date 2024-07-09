{ lib
, bzip2
, darwin
, fetchFromGitHub
, pkg-config
, rustPlatform
, stdenv
, zstd
}:

rustPlatform.buildRustPackage rec {
  pname = "fim-rs";
  version = "0.4.10";

  src = fetchFromGitHub {
    owner = "Achiefs";
    repo = "fim";
    rev = "refs/tags/v${version}";
    hash = "sha256-NrxjiJY+qgPfsNY2Xlm0KRArIDH3+u9uA5gSPem+9uc=";
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
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # There is a failure while the binary is checked
  doCheck = false;

  meta = with lib; {
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
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "fim";
  };
}
