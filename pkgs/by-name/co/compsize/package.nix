{
  lib,
  stdenv,
  fetchFromGitHub,
  btrfs-progs,
}:

stdenv.mkDerivation {
  pname = "compsize";
  version = "1.5-unstable-2023-12-24";

  src = fetchFromGitHub {
    owner = "kilobyte";
    repo = "compsize";
    rev = "d79eacf77abe3b799387bb8a4e07a18f1f1031e8";
    sha256 = "sha256-pwHFllwTznhgZAGtGsULoLLBZlCllGt1eBmUKoJ/2wk=";
  };

  patches = [
    ./btrfs-progs-6-10-1.patch
  ];

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  outputs = [
    "out"
    "man"
  ];

  buildInputs = [ btrfs-progs ];

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "Find compression type/ratio on a file or set of files in the Btrfs filesystem";
    mainProgram = "compsize";
    homepage = "https://github.com/kilobyte/compsize";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ sandarukasa ];
    platforms = lib.platforms.linux;
  };
}
