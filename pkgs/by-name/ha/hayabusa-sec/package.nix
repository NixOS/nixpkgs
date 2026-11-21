{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  pkg-config,
  libgit2,
  openssl,
  rust-jemalloc-sys,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hayabusa-sec";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "Yamato-Security";
    repo = "hayabusa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C5gVxNb5Jn1Eq+5JmzHjGWyAM8jy+ap037dRaIhrVQ4=";
    # Include the hayabusa-rules
    fetchSubmodules = true;
  };

  cargoHash = "sha256-yoDi/W1+0ayIpYuJKfzl83abQgqGPCC39VXwoR9+YHY=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    rust-jemalloc-sys # transitive dependency via the hayabusa-evtx crate
  ];

  env.OPENSSL_NO_VENDOR = true;

  # Several checks panic
  # Skipping individual checks causes failure as `--skip` flags
  # end up passed to executing `hayabusa`
  # > error: unexpected argument '--skip' found
  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/hayabusa-sec
    cp -r rules $out/share/hayabusa-sec/
    mv $out/bin/hayabusa $out/share/hayabusa-sec/
    makeWrapper $out/share/hayabusa-sec/hayabusa $out/bin/hayabusa
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sigma-based threat hunting and fast forensics timeline generator for Windows event logs";
    homepage = "https://github.com/Yamato-Security/hayabusa";
    changelog = "https://github.com/Yamato-Security/hayabusa/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      jk
      d3vil0p3r
    ];
    mainProgram = "hayabusa";
  };
})
