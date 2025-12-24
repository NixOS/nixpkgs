{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "c-ascii-render";
  version = "0-unstable-2025-11-18";

  src = fetchFromGitHub {
    owner = "Lallapallooza";
    repo = "c_ascii_render";
    rev = "c1894b50488c6ba75e33734d6b3d4a3397ac1fb5";
    hash = "sha256-sqGKUbv8OCWAs7Rxe2H6+xHQJivBkGM7K13GdNuPVd8=";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '/usr/local' '${placeholder "out"}'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple ASCII Render using Pure C";
    homepage = "https://github.com/Lallapallooza/c_ascii_render";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "c-ascii-render";
    platforms = lib.platforms.all;
  };
}
