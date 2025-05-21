{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  which,
}:

buildGoModule (finalAttrs: {
  pname = "landrun";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "Zouuup";
    repo = "landrun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yfK7Q3FKXp5pXVBNV0w/vN0xuoaTxWCq19ziBQnLapg=";
  };

  # Test script requires lots of patching for build sandbox.
  # Networking tests are disabled, since they actually access the internet.
  # Two tests that specifically target /usr/bin are disabled.
  postPatch = ''
    patchShebangs --build test.sh
    substituteInPlace test.sh \
      --replace-fail 'Basic access tests' '# Basic access tests' \
      --replace-fail '--rox /usr --ro /lib --ro /lib64' '--rox ${builtins.storeDir}' \
      --replace-fail '--rox /usr --ro /lib,/lib64,' '--rox ${builtins.storeDir} --ro ' \
      --replace-fail '--rox /usr --ro  /etc -- whoami' '--help' \
      --replace-fail '--rox /usr' '--rox ${builtins.storeDir}' \
      --replace-fail '--ro /usr/bin' "" \
      --replace-fail '#!/bin/bash' '#!${stdenv.shell}' \
      --replace-fail '/usr/bin/true' '$(which true)' \
      --replace-fail 'ls /usr | grep bin' '$(which ls) / | $(which grep) build' \
      --replace-fail 'ls /usr' '$(which ls) /build' \
      --replace-fail 'cat ' '$(which cat) ' \
      --replace-fail 'grep ' '$(which grep) ' \
      --replace-fail 'ls -la /usr/bin' 'ls -la /build' \
      --replace-fail 'run_test "TCP connection' 'false && run_test "TCP' \
      --replace-fail 'run_test "Unrestricted network access"' 'false && run_test ""' \
      --replace-fail 'run_test "Restricted network access"' 'false && run_test ""' \
      --replace-fail 'run_test "Execute from read-only paths regression test' 'false && run_test "' \
      --replace-fail 'run_test "Root path' 'false && run_test "Root path'
  '';

  vendorHash = "sha256-Bs5b5w0mQj1MyT2ctJ7V38Dy60moB36+T8TFH38FA08=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    which
  ];
  postInstallCheck = ''
    # only check functionality if the builder supports it (Linux 5.13+)
    set +e
    $out/bin/landrun --best-effort --rox ${builtins.storeDir} sh -c 'exit'
    [[ $? != 0 ]] && set -e && return
    set -e

    # only run upstream tests if the builder supports all features (Linux 6.7+)
    set +e
    $out/bin/landrun --rox ${builtins.storeDir} sh -c 'exit'
    [[ $? == 0 ]] && set -e && export PATH=$out/bin:"$PATH" && ./test.sh --use-system
    set -e

    pushd $(mktemp -d)

    # check directory read/write restrictions work
    mkdir dir1
    echo content > dir1/file1

    set +e
    $out/bin/landrun --best-effort --rox ${builtins.storeDir} sh -c '< dir1/file1'
    [[ $? == 0 ]] && die
    set -e

    $out/bin/landrun --best-effort --rox ${builtins.storeDir} --ro ./dir1 --env PATH sh -c 'cat dir1/file1' \
      | grep content > /dev/null

    set +e
    $out/bin/landrun --best-effort --rox ${builtins.storeDir} --ro ./dir1 sh -c 'echo x > dir1/file1'
    [[ $? == 0 ]] && die
    set -e
    cat dir1/file1 | grep content > /dev/null

    $out/bin/landrun --best-effort --rox ${builtins.storeDir} --rw ./dir1 sh -c 'echo x > dir1/file1'
    cat dir1/file1 | grep x > /dev/null

    popd
  '';

  meta = {
    description = "Lightweight, secure sandbox for running Linux processes using Landlock LSM";
    mainProgram = "landrun";
    longDescription = ''
      Landrun is designed to make it practical to sandbox any command with fine-grained filesystem
      and network access controls, without root/containers/SELinux/AppArmor.

      It's lightweight, auditable, and wraps Landlock v5 features.

      Linux 5.13+ is required for file access restrictions, Linux 6.7+ for TCP restrictions.
    '';
    homepage = "https://github.com/Zouuup/landrun";
    changelog = "https://github.com/Zouuup/landrun/releases/tag/{finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.fliegendewurst ];
    platforms = lib.platforms.linux;
  };
})
