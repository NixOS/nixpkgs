{
  stdenv,
  fetchFromGitHub,
  boost,
  fuse,
  nix,
  lib,
}:
stdenv.mkDerivation (final: {
  pname = "dwarffs";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "dwarffs";
    rev = "v${final.version}";
    hash = "sha256-n3go513OO7HqfPsolxPga7pbRcv38KjuyTvVTNLkthA=";
  };

  strictDeps = true;

  buildInputs = [
    boost
    fuse
    nix
  ];
  env.NIX_CFLAGS_COMPILE = "-I${nix.dev}/include/nix -D_FILE_OFFSET_BITS=64 -DVERSION=\"${final.version}\"";

  installPhase = ''
    runHook preInstall

    install -Dm755 dwarffs "$out/bin/dwarffs"
    ln -s dwarffs "$out/bin/mount.fuse.dwarffs"

    install -Dm644 run-dwarffs.mount "$out/lib/systemd/system/run-dwarffs.mount"
    install -Dm644 run-dwarffs.automount "$out/lib/systemd/system/run-dwarffs.automount"

    runHook postInstall
  '';

  meta = {
    description = "A filesystem that fetches DWARF debug info from the Internet on demand";
    homepage = "https://github.com/edolstra/dwarffs";
    license = [ lib.licenses.gpl3Only ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.alois31 ];
  };
})
