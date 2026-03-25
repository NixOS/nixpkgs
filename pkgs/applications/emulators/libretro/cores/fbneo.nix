{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-03-17";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "baafb100b487f2ac06f9e78ac322e3ecf36b8924";
    hash = "sha256-46hVbQN8QO1FNm56wJ7Q323blUWV9sn529tMwdAOhW8=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
