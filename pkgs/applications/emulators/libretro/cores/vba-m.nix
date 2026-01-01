{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vbam";
<<<<<<< HEAD
  version = "0-unstable-2025-12-10";
=======
  version = "0-unstable-2025-11-25";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vbam-libretro";
<<<<<<< HEAD
    rev = "b269c9c3eb05da5e2adf3a512873224e3164dea3";
    hash = "sha256-SwBLeCa233RMp4lJf3pv7aegy9jd/M/GO7T9jbIuBY8=";
=======
    rev = "c3db5dc221a3038ee54572047304963cbca15cd6";
    hash = "sha256-e+elKAcQXTVH2VtW0J4FG2p6bJTWSuxrIrnMHwjaO9I=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  makefile = "Makefile";
  preBuild = "cd src/libretro";

  meta = {
    description = "VBA-M libretro port";
    homepage = "https://github.com/libretro/vbam-libretro";
    license = lib.licenses.gpl2Only;
  };
}
