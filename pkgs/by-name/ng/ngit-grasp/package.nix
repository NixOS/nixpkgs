{
  cacert,
  fetchgit,
  git,
  lib,
  makeWrapper,
  openssh,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ngit-grasp";
  version = "3.0.3";

  __structuredAttrs = true;

  # The tests start relay fixtures on loopback sockets.
  __darwinAllowLocalNetworking = true;

  src = fetchgit {
    url = "https://ngit.dev/ngit-grasp.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iBtw3rKKdmm93fjFJXgibRSSwK/NFf9rDrD421JjMqY=";
  };

  cargoHash = "sha256-iDZ00vCz+SjjBw+plhmpoIUCoKvzJhaDrbRPQau72ow=";

  # Test portability and sandbox failure diagnostics; submitted upstream:
  # https://gitworkshop.dev/nevent1qqswj6egflzl5acvhrx2ld2gv8ucv4k654kyu5rh3sphxkjmgfw9hsqpz3mhxue69uhhyetvv9ujumn8d96zuer9wckj9pcq
  patches = [
    ./metrics-platforms.patch
    ./relay-failure-logs.patch
    ./darwin-listener.patch
  ];

  postPatch = ''
    # This test creates its fake Git script at runtime, after shebang patching.
    substituteInPlace tests/git_response_streaming.rs \
      --replace-fail '#!/usr/bin/env bash' '#!${stdenv.shell}'
  '';

  cargoBuildFlags = [
    "-p"
    "ngit-grasp"
  ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [ openssl ];

  propagatedUserEnvPkgs = [
    git
    openssh
  ];

  nativeCheckInputs = [
    cacert
    git
  ];

  # Run the package suite, including integration tests with local relay fixtures.
  cargoTestFlags = [
    "-p"
    "ngit-grasp"
  ];

  postInstall = ''
    wrapProgram "$out/bin/ngit-grasp" \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          openssh
        ]
      } \
      --set-default SSL_CERT_FILE ${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  versionCheckProgram = "${placeholder "out"}/bin/ngit-grasp";

  meta = {
    description = "Distributed Git hosting service powered by Nostr";
    homepage = "https://ngit.dev/ngit-grasp";
    changelog = "https://ngit.dev/ngit-grasp/changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danconwaydev ];
    mainProgram = "ngit-grasp";
    platforms = lib.platforms.unix;
  };
})
