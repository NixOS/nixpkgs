{
  lib,
  alsa-lib,
  fetchfromgithub,
  mklibretrocore,
  python3,
}:
mklibretrocore {
  core = "mame2016";
  version = "unstable-2024-04-06";

        "src": {
            "owner": "libretro",
            "repo": "mame2016-libretro",
            "rev": "01058613a0109424c4e7211e49ed83ac950d3993",
            "hash": "sha256-IsM7f/zlzvomVOYlinJVqZllUhDfy4NNTeTPtNmdVak="
        },

  patches = [ ./patches/mame2015-python311.patch ];
  makeflags = [ "python=python3" ];
  extranativebuildinputs = [ python3 ];
  extrabuildinputs = [ alsa-lib ];
  makefile = "makefile";
  # build failures when this is set to a bigger number
  nix_build_cores = 8;

  meta = {
    description = "port of mame ~2015 to libretro, compatible with mame 0.160 sets";
    homepage = "https://github.com/libretro/mame2015-libretro";
    # mame license, non-commercial clause
    license = lib.licenses.unfreeredistributable;
  };
}
