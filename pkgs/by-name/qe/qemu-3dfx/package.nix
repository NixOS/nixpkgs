# qemu-3dfx — QEMU 9.2.x with kjliew/qemu-3dfx 3Dfx Glide and MesaGL
# pass-through device models for retro Windows and DOS games.
#
# Updating: run `./update.sh`. The five pinned values below
# (qemu3dfxRev, qemu3dfxHash, qemu3dfxDate, qemuVersion, qemuHash) are
# bumped in coordination by sed.
#
# When upstream qemu-3dfx adopts a new QEMU major.minor (e.g. 10.x),
# the embedded patch filename also changes — this is a manual edit to
# the `patches` line below and the version regex in `update.sh`.

{
  lib,
  callPackage,
  stdenv,
  qemu,
  fetchurl,
  fetchFromGitHub,
  libxxf86vm,
}:

let
  qemu3dfxRev = "9ac7b6e441986f18a46059132c63fa877fb9a6d8";
  qemu3dfxHash = "sha256-POxJPk/sGXFRn/AzpT1IjdFrV9abppf1eVneTpUNb6w=";
  qemu3dfxDate = "2026-04-30";
  qemuVersion = "9.2.4";
  qemuHash = "sha256-88wcTqv9soghisPjN2Pb6eJ22LyJC4Z6IzXVjeLd05o=";

  qemu-3dfx-src = fetchFromGitHub {
    owner = "kjliew";
    repo = "qemu-3dfx";
    rev = qemu3dfxRev;
    hash = qemu3dfxHash;
  };
  shortRev = lib.substring 0 7 qemu3dfxRev;

  guestWrappersArgs = { inherit qemu-3dfx-src shortRev; };

  guest-wrappers-windows = callPackage ./guest-wrappers/windows.nix guestWrappersArgs;
  guest-wrappers-djgpp = callPackage ./guest-wrappers/djgpp.nix guestWrappersArgs;
  guest-wrappers-watcom = callPackage ./guest-wrappers/watcom.nix guestWrappersArgs;
  guest-wrappers-iso = callPackage ./guest-wrappers/iso.nix {
    inherit guest-wrappers-windows guest-wrappers-djgpp guest-wrappers-watcom;
  };
in
qemu.overrideAttrs (prev: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "qemu-3dfx";
  version = "${qemuVersion}-unstable-${qemu3dfxDate}";

  src = fetchurl {
    url = "https://download.qemu.org/qemu-${qemuVersion}.tar.xz";
    hash = qemuHash;
  };

  buildInputs = prev.buildInputs ++ [ libxxf86vm ];

  # Replace (not append to) nixpkgs's qemu patches. kjliew/qemu-3dfx is
  # developed against pristine upstream qemu source trees, and several of
  # nixpkgs's patches target qemu 10.x and don't apply to 9.2.x.
  patches = [ "${qemu-3dfx-src}/00-qemu92x-mesa-glide.patch" ];

  postPatch = ''
    cp -r ${qemu-3dfx-src}/qemu-0/hw/3dfx ./hw/
    cp -r ${qemu-3dfx-src}/qemu-1/hw/mesa ./hw/
    chmod -R u+w hw/3dfx hw/mesa

    # sign_commit performs in-tree fix-ups for the patched device models
    # (HASH_ALGO substitution, sysbus path rewrites, system_ss vs i386_ss
    # selection) and stamps a `rev_[]` string into headers. Replace its
    # single `git rev-parse` call so the build is hermetic.
    cp ${qemu-3dfx-src}/scripts/sign_commit ./scripts/qemu-3dfx-sign
    chmod u+w ./scripts/qemu-3dfx-sign
    substituteInPlace ./scripts/qemu-3dfx-sign \
      --replace-fail 'git rev-parse --short $ARG' 'echo ${shortRev}'
    bash ./scripts/qemu-3dfx-sign
  ''
  + (prev.postPatch or "");

  passthru = (prev.passthru or { }) // {
    guestWrappers = {
      windows = guest-wrappers-windows;
      djgpp = guest-wrappers-djgpp;
      watcom = guest-wrappers-watcom;
      iso = guest-wrappers-iso;
    };

    tests = {
      inherit
        guest-wrappers-windows
        guest-wrappers-djgpp
        guest-wrappers-watcom
        guest-wrappers-iso
        ;
    };

    updateScript = ./update.sh;
  };

  meta = {
    description = "QEMU ${qemuVersion} with kjliew/qemu-3dfx 3Dfx Glide and MesaGL pass-through for retro Windows/DOS games";
    homepage = "https://github.com/kjliew/qemu-3dfx";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ io12 ];
    mainProgram = "qemu-system-i386";
  };
})
