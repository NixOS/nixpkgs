{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nixosTests,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "envfs";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "envfs";
    rev = finalAttrs.version;
    hash = "sha256-hj/6zS9ebF0IDqgc1Dne59nWx80nk6jn2gj8BzQUFIQ=";
  };

  cargoHash = "sha256-dz3gpE464jnmSDsAsmJHcxUsEKeUURNoUjgGU2214Xg=";

  postInstall = ''
    ln -s envfs $out/bin/mount.envfs
    ln -s envfs $out/bin/mount.fuse.envfs
  '';

  passthru = {
    tests = {
      inherit (nixosTests) envfs envfs-systemd-stage-1;
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
