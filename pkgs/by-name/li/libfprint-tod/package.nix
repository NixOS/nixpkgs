{
  lib,
  libfprint,
  fetchFromGitLab,
}:

# for the curious, "tod" means "Touch OEM Drivers" meaning it can load
# external .so's.
libfprint.overrideAttrs (
  {
    postPatch ? "",
    mesonFlags ? [ ],
    ...
  }:
  let
    version = "1.94.10";
  in
  {
    pname = "libfprint-tod";
    inherit version;

    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "3v1n0";
      repo = "libfprint";
      rev = "v${version}";
      hash = "sha256-aNBUIKY3PP5A07UNg3N0qq+2cwb6Fk67oKQcXgr2G/4=";
    };

    mesonFlags = [
      # Include virtual drivers for fprintd tests
      "-Ddrivers=all"
      "-Dudev_hwdb_dir=${placeholder "out"}/lib/udev/hwdb.d"
      "-Dudev_rules_dir=${placeholder "out"}/lib/udev/rules.d"
    ];

    postPatch = ''
      ${postPatch}
      patchShebangs \
        ./libfprint/tod/tests/*.sh \
        ./tests/*.py \
        ./tests/*.sh \
    '';

    meta = {
      homepage = "https://gitlab.freedesktop.org/3v1n0/libfprint";
      description = "Library designed to make it easy to add support for consumer fingerprint readers, with support for loaded drivers";
      license = lib.licenses.lgpl21;
      platforms = lib.platforms.linux;
    };
  }
)
