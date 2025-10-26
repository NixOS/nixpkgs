{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jrl-cmakemodules";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "jrl-umi3218";
    repo = "jrl-cmakemodules";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WQiAAexshQ4zgaBNo/CD91XV+PAeoPZatmehSA14aPM=";
  };

  patches = [
    # ref. https://github.com/jrl-umi3218/jrl-cmakemodules/pull/783
    (fetchpatch {
      name = "fix-permissions.patch";
      url = "https://github.com/jrl-umi3218/jrl-cmakemodules/commit/defed70c8a7c5e4bd5b26006bef26e3fb22c3b26.patch";
      hash = "sha256-muO6DwQhNPCv6DPmnHnEHjsh/FSj0ljgNCb+ZowLRaY=";
    })
  ];

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
