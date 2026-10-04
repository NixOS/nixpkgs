{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  gitMinimal,
  libpcap,
  llvmPackages,
  protobuf,
  python3,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "libtelio";
  # nixpkgs-update: no auto update
  version = "6.2.4"; # keep in sync with LIBTELIO_VERSION in nordvpn-linux's lib-versions.env
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NordSecurity";
    repo = "libtelio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mnGVkTfpHiig+FnXQivIP+d0AYWZ6z2wu6XcQHP0p1E=";
    # pulls in 3rd-party/rust_build_utils, referenced from build.rs
    fetchSubmodules = true;
  };

  # skip git-secrets pre-commit-hook
  env.BYPASS_LLT_SECRETS = "1";

  # llt-proto's published crate is missing a .proto file its build.rs needs
  cargoPatches = [
    ./llt-proto-rev.patch
  ];

  # do not re-exec with sudo
  patches = [
    ./libtelio.patch
  ];

  postPatch = ''
    patchShebangs test_runner.sh
  '';

  cargoHash = "sha256-9sbWBAo+Ok+2g9srI/loN1Rwv75Qi5xFCmJHBooekKs=";

  nativeBuildInputs = [
    cmake # required for aws-lc-sys
    gitMinimal # required for neptun, falls back to empty string
    protobuf # required for llt-proto
    python3
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    llvmPackages.libclang.lib
    libpcap
  ];

  # avoid building the unrelated clis/* workspace members
  buildAndTestSubdir = ".";
  cargoBuildFlags = [
    "-p"
    "telio"
  ];

  cargoTestFlags = [
    "--"
    "--skip=device::tests::test_default_features_when_provider_is_empty"
    "--skip=device::tests::test_default_features_when_direct_is_empty"
    "--skip=device::tests::test_enable_all_direct_features"
  ];

  doCheck = true;

  # save shared object before cargo test relinks it with a test only variant
  postBuild = ''
    install -Dm755 "$(find target -name libtelio.so -path '*/release/*' | head -1)" "$TMPDIR/libtelio.so"
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 "$TMPDIR/libtelio.so" -t $out/lib
    runHook postInstall
  '';

  # telio_utils::git::version_tag() reads the version from a fixed offset
  postFixup = ''
    python3 -c "
    path = '$out/lib/libtelio.so'
    placeholder = b'VERSION_PLACEHOLDER' + b'@' * 109 + b'\0'
    assert len(placeholder) == 129
    new = ('${finalAttrs.version}'.encode() + b'\0' * 129)[:129]
    with open(path, 'r+b') as f:
      data = f.read()
      assert data.count(placeholder) == 1
      f.seek(0)
      f.write(data.replace(placeholder, new))
    "
  '';

  meta = {
    description = "Native meshnet library used by NordVPN's meshnet feature";
    homepage = "https://github.com/NordSecurity/libtelio";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ novalkun ];
    platforms = lib.platforms.linux;
  };
})
