{
  buildGo127Module,
  fetchFromGitHub,
  lib,
  nixosTests,
  stdenv,
}:

buildGo127Module (finalAttrs: {
  pname = "ghostunnel";
  version = "1.11.5";

  src = fetchFromGitHub {
    owner = "ghostunnel";
    repo = "ghostunnel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nGnFuTZDCMAx4x0QPptYhv/UTO+opw97HIvaxqgQHPA=";
  };

  vendorHash = null;

  deleteVendor = true;

  patches = [
    # A flag for extra paths in the landlock sandbox.
    # Needed for config files in the store, for instance.
    # Not offered upstream yet.
    ./landlock-allow-read.patch
    # A flag to exit when the landlock sandbox cannot be set up, where
    # upstream logs a warning and runs without it.
    # Not offered upstream yet.
    ./require-landlock.patch
  ];

  checkFlags = [
    # These tests don't exist for Linux, and on Darwin they attempt to use the macOS Keychain
    # which doesn't work from a nix build. Presumably other platform implementations of the
    # certstore would have similar issues, so it probably makes sense to skip them in
    # general wherever they are available.
    "-skip=^Test(ImportDelete|Signer|Certificate)(RSA|ECDSA|EC)$"
    # These tests should work in the nix build, since they only use local networking. For some
    # reason they aren't working though.
    "-skip=^TestACMEInitialIssuance"
  ];

  # The flags are Linux-only, like the sandbox.
  doInstallCheck = stdenv.hostPlatform.isLinux;
  # With --require-landlock, ghostunnel must exit when it would run without
  # the sandbox: with --disable-landlock, with PKCS#11, or when the setup
  # fails, here because of a bad --landlock-allow-read.
  installCheckPhase = ''
    runHook preInstallCheck
    last_error() {
      local output
      if output=$($out/bin/ghostunnel --require-landlock "$@" server --listen localhost:8443 --target localhost:8080 --disable-authentication 2>&1); then
        echo "ghostunnel did not exit with an error: $*"
        exit 1
      fi
      echo "''${output##*$'\n'}"
    }
    expect() {
      local actual
      actual=$(last_error "''${@:2}")
      if [[ $actual != "$1" ]]; then
        echo "expected: $1"
        echo "actual: $actual"
        exit 1
      fi
    }
    expect "error: --require-landlock conflicts with --disable-landlock" --disable-landlock
    # ghostunnel checks the conflict before it loads the module.
    touch "$TMPDIR/empty.so"
    expect "error: --require-landlock conflicts with pkcs11, which skips landlock" --pkcs11-module="$TMPDIR/empty.so"
    if [[ $(last_error --landlock-allow-read="$TMPDIR") == "error: unable to set up landlock: kernel does not support landlock: "* ]]; then
      echo "skipping the checks that need landlock, because the build kernel does not support it"
    else
      touch "$TMPDIR/not-a-dir"
      expect "error: unable to set up landlock: populating ruleset for \"$TMPDIR/not-a-dir\" with access {read_file,read_dir}: landlock_add_rule: inconsistent access rights (using directory access rights on a regular file?): invalid argument" --landlock-allow-read="$TMPDIR/not-a-dir"
      expect "error: unable to set up landlock: populating ruleset for \"$TMPDIR/missing\" with access {read_file,read_dir}: open: no such file or directory" --landlock-allow-read="$TMPDIR/missing"
    fi
    runHook postInstallCheck
  '';

  passthru.tests = {
    nixos = nixosTests.ghostunnel;
    nixos-no-nscd = nixosTests.ghostunnel-no-nscd;
    nixos-modular = nixosTests.ghostunnel-modular;
    nixos-modular-no-nscd = nixosTests.ghostunnel-modular-no-nscd;
    podman = nixosTests.podman-tls-ghostunnel;
  };

  passthru.services.default = {
    imports = [
      (lib.modules.importApply ./service.nix { })
    ];
    ghostunnel.package = finalAttrs.finalPackage;
  };

  meta = {
    description = "TLS proxy with mutual authentication support for securing non-TLS backend applications";
    longDescription = ''
      On Linux, ghostunnel restricts itself with a landlock sandbox. The
      Nixpkgs build adds a `--landlock-allow-read` flag, which lets the sandbox
      read files and list directories in a further path. On NixOS, many paths
      in /etc are symlinks into the Nix store, so run ghostunnel with
      `--landlock-allow-read=''${builtins.storeDir}` there. When ghostunnel cannot set up
      the sandbox, for example because a `--landlock-allow-read` path is a file
      or does not exist, it logs a warning and runs without the sandbox. The
      Nixpkgs build adds a `--require-landlock` flag, which makes it exit
      instead. The NixOS module and the modular service pass both flags by
      default.
    '';
    homepage = "https://github.com/ghostunnel/ghostunnel#readme";
    changelog = "https://github.com/ghostunnel/ghostunnel/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      roberth
      mjm
    ];
    mainProgram = "ghostunnel";
  };
})
