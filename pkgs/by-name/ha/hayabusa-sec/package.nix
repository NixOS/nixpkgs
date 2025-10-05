{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  rust-jemalloc-sys,
}:

rustPlatform.buildRustPackage {
  pname = "hayabusa-sec";
  version = "3.3.0-unstable-2025-07-17";

  src = fetchFromGitHub {
    owner = "Yamato-Security";
    repo = "hayabusa";
    rev = "feaa165b4c0af34919ad26f634cb684e23172359";
    hash = "sha256-h08InhNVW33IjPA228gv6Enlg6EKmj0yHb/UvJ/f7uw=";
    # Include the hayabusa-rules
    fetchSubmodules = true;
  };

  cargoHash = "sha256-wcH1Ron5Zx2ypWyaW0z7L9rCanAcosvpPQnP60qbvWQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    rust-jemalloc-sys # transitive dependency via the hayabusa-evtx crate
  ];

  env.OPENSSL_NO_VENDOR = true;

  # Several checks panic
  # Skipping individual checks causes failure as `--skip` flags
  # end up passed to executing `hayabusa`
  # > error: unexpected argument '--skip' found
  doCheck = false;

  meta = {
    description = "Sigma-based threat hunting and fast forensics timeline generator for Windows event logs";
    homepage = "https://github.com/Yamato-Security/hayabusa";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      d3vil0p3r
      jk
    ];
    mainProgram = "hayabusa";
  };
}
