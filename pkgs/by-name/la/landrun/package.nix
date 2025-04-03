{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "landrun";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "Zouuup";
    repo = "landrun";
    tag = "v${version}";
    hash = "sha256-k6xwE733N7mNSs8TfPOFFJkwdiOuqojL+XmDAOlDgMY=";
  };

  vendorHash = "sha256-Bs5b5w0mQj1MyT2ctJ7V38Dy60moB36+T8TFH38FA08=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  postInstallCheck = ''
    pushd $(mktemp -d)

    # only check functionality if the builder supports it (Linux 5.13+)
    set +e
    $out/bin/landrun --best-effort --rox ${builtins.storeDir} sh -c 'exit'
    [[ $? != 0 ]] && popd && return
    set -e

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
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.fliegendewurst ];
    platforms = lib.platforms.linux;
  };
}
