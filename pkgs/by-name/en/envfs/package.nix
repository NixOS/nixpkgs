{
  rustPlatform,
  lib,
  fetchFromGitHub,
  nixosTests,
}:
rustPlatform.buildRustPackage rec {
  pname = "envfs";
  version = "1.0.6";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "envfs";
    rev = version;
    hash = "sha256-kOfnKguvJQHW/AfQOetxVefjoEj7ec5ew6fumhOwP08=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-VvdvYxNBzwJJy09npC30VaOzOU9Fwi++qon9Od4juHE=";

  passthru.tests = {
    envfs = nixosTests.envfs;
  };

  postInstall = ''
    ln -s envfs $out/bin/mount.envfs
    ln -s envfs $out/bin/mount.fuse.envfs
  '';
  meta = with lib; {
    description = "Fuse filesystem that returns symlinks to executables based on the PATH of the requesting process";
    homepage = "https://github.com/Mic92/envfs";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.linux;
  };
}
