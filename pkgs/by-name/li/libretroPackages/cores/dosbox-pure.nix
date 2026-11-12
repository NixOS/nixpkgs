{
  lib,
  fetchFromCodeberg,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "dosbox-pure";
  version = "0-unstable-2026-11-07";

  src = fetchFromCodeberg {
    owner = "schelling";
    repo = "dosbox-pure";
    rev = "9cccfa21cb117edf94fbcd1a26b2dee8b12db598";
    hash = "sha256-jA9ZPqykpcrexrjVXpKnB27n5mSH98EUJK6cTI44F3s=";
  };

  hardeningDisable = [ "format" ];
  makefile = "Makefile";

  meta = {
    description = "Port of DOSBox to libretro aiming for simplicity and ease of use";
    homepage = "https://codeberg.org/schelling/dosbox-pure";
    license = lib.licenses.gpl2Only;
  };
}
