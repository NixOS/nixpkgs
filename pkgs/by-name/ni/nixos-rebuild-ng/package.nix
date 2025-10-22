{
  stdenv,
  python3Packages,

  # These are required to be passed through.
  installShellFiles,
  lixPackageSets,
  mkShell,
  nix,
  nixVersions,
  nixos-rebuild-ng,
  nixosTests,
  scdoc,

  withNgSuffix ? true,
  withReexec ? false,
  withShellFiles ? true,
  # Very long tmp dirs lead to "too long for Unix domain socket"
  # SSH ControlPath errors. Especially macOS sets long TMPDIR paths.
  withTmpdir ? if stdenv.hostPlatform.isDarwin then "/tmp" else null,
}:

python3Packages.callPackage ./python.nix {
  inherit
    installShellFiles
    lixPackageSets
    mkShell
    nix
    nixVersions
    nixos-rebuild-ng
    nixosTests
    scdoc
    withNgSuffix
    withReexec
    withShellFiles
    withTmpdir
    ;
}
