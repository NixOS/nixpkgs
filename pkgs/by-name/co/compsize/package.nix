{
  lib,
  stdenv,
  fetchFromGitHub,
  btrfs-progs,
}:

stdenv.mkDerivation rec {
  pname = "compsize";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "kilobyte";
    repo = "compsize";
    rev = "v${version}";
    sha256 = "sha256-OX41ChtHX36lVRL7O2gH21Dfw6GPPEClD+yafR/PFm8=";
  };

  patches = [
    ./btrfs-progs-6-10-1.patch
  ];

  buildInputs = [ btrfs-progs ];

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  preInstall = ''
    mkdir -p $out/share/man/man8
  '';

  meta = {
    description = "Find compression type/ratio on a file or set of files in the Btrfs filesystem";
    mainProgram = "compsize";
    homepage = "https://github.com/kilobyte/compsize";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ sandarukasa ];
    platforms = lib.platforms.linux;
  };
}
