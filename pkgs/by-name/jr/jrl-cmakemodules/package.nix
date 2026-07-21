{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jrl-cmakemodules";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "jrl-umi3218";
    repo = "jrl-cmakemodules";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S9MRMV+xv70tIMFRpj7SQjHiBvMHZvDmG5eeuyzO5zQ=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CMake utility toolbox";
    homepage = "https://github.com/jrl-umi3218/jrl-cmakemodules";
    changelog = "https://github.com/jrl-umi3218/jrl-cmakemodules/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.all;
  };
})
