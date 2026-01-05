{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  btrfs-progs,
}:

let
  # https://github.com/kilobyte/compsize/issues/52
  btrfs-progs' = btrfs-progs.overrideAttrs (old: rec {
    pname = "btrfs-progs";
    version = "6.10";
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${version}.tar.xz";
      hash = "sha256-M4KoTj/P4f/eoHphqz9OhmZdOPo18fNFSNXfhnQj4N8=";
    };
  });

in
stdenv.mkDerivation rec {
  pname = "compsize";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "kilobyte";
    repo = "compsize";
    rev = "v${version}";
    sha256 = "sha256-OX41ChtHX36lVRL7O2gH21Dfw6GPPEClD+yafR/PFm8=";
  };

  buildInputs = [ btrfs-progs' ];

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  preInstall = ''
    mkdir -p $out/share/man/man8
  '';

  meta = with lib; {
    description = "Find compression type/ratio on a file or set of files in the Btrfs filesystem";
    mainProgram = "compsize";
    homepage = "https://github.com/kilobyte/compsize";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
