{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  python3,
  versionCheckHook,
  which,
}:

buildGoModule (finalAttrs: {
  pname = "landrun";
  version = "0.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Zouuup";
    repo = "landrun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s7KYLu2VWcIjtuQUQuIyHLaQZIMTDe5xrtz1bXtt1Vo=";
  };

  vendorHash = "sha256-uGoRDRkSRLJ3StD0fkiNL/tr/N5j+ubSVMWrCBHRq48=";

  # Upstream release binaries are built with cgo disabled.
  env.CGO_ENABLED = 0;

  # Fails when the builder's kernel lacks Landlock; test.sh covers the same case.
  checkFlags = [ "-skip=^TestApplySubprocessMissingPathFails$" ];

  preCheck = ''
    substituteInPlace internal/sandbox/sandbox_test.go \
      --replace-fail '"/usr"' '"${builtins.storeDir}"'
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    python3
    versionCheckHook
    which
  ];

  # What Landlock enforces depends on the builder's kernel; checks needing
  # a newer Landlock ABI than the builder has are skipped.
  postInstallCheck = ''
    landlock_abi=$("$out/bin/landrun" --best-effort --log-level debug --rox ${builtins.storeDir} -- true 2>&1 \
      | sed -n 's/.*Detected Landlock ABI v\([0-9][0-9]*\).*/\1/p')
    if [[ -z $landlock_abi ]]; then
      echo "landrun did not report the Landlock ABI" >&2
      exit 1
    fi
    echo "Landlock ABI of the builder: v$landlock_abi"
    if (( landlock_abi < 1 )); then
      echo "Landlock is unavailable on the builder; skipping sandbox tests"
      return
    fi

    pushd "$(mktemp -d)"
    mkdir dir1
    echo content > dir1/file1

    if "$out/bin/landrun" --rox ${builtins.storeDir} -- sh -c '< dir1/file1'; then
      echo "landrun allowed reading a path without a rule" >&2
      exit 1
    fi
    "$out/bin/landrun" --rox ${builtins.storeDir} --ro ./dir1 --env PATH -- sh -c 'cat dir1/file1' \
      | grep -qx content
    if "$out/bin/landrun" --rox ${builtins.storeDir} --ro ./dir1 -- sh -c 'echo x > dir1/file1'; then
      echo "landrun allowed writing a read-only path" >&2
      exit 1
    fi
    grep -qx content dir1/file1
    "$out/bin/landrun" --best-effort --rox ${builtins.storeDir} --rw ./dir1 -- sh -c 'echo x > dir1/file1'
    grep -qx x dir1/file1
    popd

    # The upstream suite expects TCP restrictions (Landlock ABI v4, Linux 6.7+).
    if (( landlock_abi < 4 )); then
      echo "Landlock ABI v$landlock_abi is older than v4; skipping upstream test suite"
      return
    fi

    # The suite assumes an FHS layout; the Nix sandbox has only the store.
    patchShebangs --build test.sh
    substituteInPlace test.sh \
      --replace-fail 'go run github.com/landlock-lsm/go-landlock/cmd/landlock-abi-version' "echo $landlock_abi" \
      --replace-fail '#!/bin/bash' '#!$BASH' \
      --replace-fail 'PYTHON=/usr/bin/python3' 'PYTHON=$(command -v python3)' \
      --replace-fail '--rox /usr --ro /lib,/lib64,' '--rox ${builtins.storeDir} --ro ' \
      --replace-fail '--ro /usr --ro /lib --ro /lib64' '--ro ${builtins.storeDir}' \
      --replace-fail '--rox /usr --ro /lib --ro /lib64' '--rox ${builtins.storeDir}' \
      --replace-fail '--rox /usr' '--rox ${builtins.storeDir}' \
      --replace-fail '--ro /usr/bin' '--ro $(dirname $(which id))' \
      --replace-fail 'ls /usr | grep bin' 'ls / | grep nix' \
      --replace-fail 'ls -la /usr/bin' 'ls -la ${builtins.storeDir}' \
      --replace-fail '$(which ls) /usr' '$(which ls) ${builtins.storeDir}' \
      --replace-fail 'ls /usr' 'ls ${builtins.storeDir}'
    PATH="$out/bin:$PATH" ./test.sh --use-system --offline
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight, secure sandbox for running Linux processes using Landlock LSM";
    longDescription = ''
      Landrun sandboxes any command with fine-grained filesystem and network
      access controls, without root, containers, SELinux or AppArmor.

      It targets Landlock ABI v11 and runs on every kernel with Landlock.
      Linux 5.13+ is required for file access restrictions, Linux 6.7+ for TCP
      restrictions and Linux 7.2+ for UDP restrictions. Without --best-effort,
      landrun refuses to run when the kernel cannot enforce an option passed
      explicitly; default restrictions the kernel cannot enforce are reported
      as warnings.
    '';
    homepage = "https://github.com/Zouuup/landrun";
    changelog = "https://github.com/Zouuup/landrun/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.fliegendewurst
      lib.maintainers.soispha
    ];
    mainProgram = "landrun";
    platforms = lib.platforms.linux;
  };
})
