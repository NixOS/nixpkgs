{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nixosTests,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "envfs";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "envfs";
    rev = finalAttrs.version;
    hash = "sha256-+RDJKyzF3jx/D5L45RybzivMjHOYe1Y4rIw9Y1G2z+g=";
  };

  cargoHash = "sha256-v3v0nGaBNCvDMVt6b5RqlgbW6uWiXHHwTGApX61abog=";

  postInstall = ''
    ln -s envfs $out/bin/mount.envfs
    ln -s envfs $out/bin/mount.fuse.envfs
  '';

  passthru = {
    tests = {
      inherit (nixosTests) envfs;
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
