{
  lib,
  fetchFromGitHub,
  gitMinimal,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "pd777";
  version = "0-unstable-2026-10-30";

  src = fetchFromGitHub {
    owner = "mittonk";
    repo = "PD777";
    rev = "13910d1cf8b139b7560fc61f7a2e0f6c95e407e5";
    hash = "sha256-2cDQZ91Fy2qbp+hDnNv/uyIwt++885rSth6wj0L+6Ig=";
  };

  sourceRoot = "source/source/libretro";

  extraNativeBuildInputs = [ gitMinimal ];

  postPatch = ''
    # The libretro Makefile writes object files outside sourceRoot.
    chmod -R u+w ../core
  '';

  meta = {
    description = "Epoch Cassette Vision emulator core for libretro";
    homepage = "https://github.com/mittonk/PD777";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
}
