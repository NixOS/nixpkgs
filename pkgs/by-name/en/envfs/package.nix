{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nixosTests,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "envfs";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "envfs";
    rev = finalAttrs.version;
    hash = "sha256-bpATdm/lB+zomPYGCxA7omWK/SKPIaqr94J+fjMaXfE=";
  };

  cargoHash = "sha256-nMUdAFRHJZDwvLASBVykzzkwk3HxslDehqqm1U99qYg=";

  postInstall = ''
    ln -s envfs $out/bin/mount.envfs
    ln -s envfs $out/bin/mount.fuse.envfs
  '';

  passthru = {
    tests = {
      envfs = nixosTests.envfs;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fuse filesystem that returns symlinks to executables based on the PATH of the requesting process";
    homepage = "https://github.com/Mic92/envfs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
    platforms = lib.platforms.linux;
  };
})
