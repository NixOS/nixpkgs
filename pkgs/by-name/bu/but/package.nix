{
  lib,
  nix-update-script,
  openssl,
  makeWrapper,
  git,
  dbus,
  pkg-config,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "but";
  version = "0.22.3";
  src = fetchFromGitHub {
    owner = "gitbutlerapp";
    repo = "gitbutler";
    tag = "release/${finalAttrs.version}";
    hash = "sha256-nW3yCbpbIhawLQVV+DptzGYiFBSKcyAP89NtDWHJM+0=";
  };

  cargoHash = "sha256-XRc2yok9K7f/vRAqgO78JUq/U36XSiUeOINupfOOSjw=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    openssl
    dbus
  ];

  nativeCheckInputs = [ git ];

  postFixup = ''
    wrapProgram $out/bin/${finalAttrs.pname} \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  env = {
    OPENSSL_NO_VENDOR = true; # tell openssl-sys: use system OpenSSL, never vendor
    VERSION = finalAttrs.version;
  };

  postPatch = ''
    # gix-testtools execve's fixture scripts directly; their `#!/usr/bin/env bash`
    # shebang can't resolve in the nix sandbox (no /usr/bin), so point them at
    # the actual bash from the build environment.
    patchShebangs crates/but/tests/fixtures/scenario/*.sh
  '';

  cargoBuildFlags = [
    "-p"
    "but"
  ];
  buildFeatures = [ "packaged-but-distribution" ];

  cargoTestFlags = [
    "-p"
    "but"
  ];
  checkFlags = lib.concatMap (t: [ "--skip=${t}" ]) [
    # TUI SVG snapshots resolve the system file-opener (xdg-open → desktop
    # associations; e.g. Thunar on Xfce) instead of upstream's fixture opener.
    "command::legacy::status::tui::tests::open_tests::"
    # These tests rely on builtin programs that only exist in debug builds
    # (#[cfg(debug_assertions)] in but-api/src/open/program.rs), while nixpkgs
    # runs the test suite with --profile release (matching what ships).
    "command::open::"
  ];
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "release/(.*)"
    ];
  };

  meta = {
    description = "GitButler CLI for virtual branches and stacked diffs";
    homepage = "https://gitbutler.com";
    changelog = "https://github.com/gitbutlerapp/gitbutler/releases/tag/release/${finalAttrs.version}";
    license = lib.licenses.fsl11Mit;
    mainProgram = "but";
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
