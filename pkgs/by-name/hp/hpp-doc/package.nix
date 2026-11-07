{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  python3Packages,

  # buildInputs
  jrl-cmakemodules,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-doc";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-doc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wP+f4n98cXuCUDfLdj3r9EfNKsWdkhklyCAiQyHJ0vg=";
  };

  prePatch = ''
    patchShebangs --build scripts/packageDep
  '';

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs ++ [
    python3Packages.python
  ];

  buildInputs = [
    jrl-cmakemodules
  ];

  propagatedBuildInputs = [
    python3Packages.hpp-practicals
    python3Packages.hpp-tutorial
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Documentation for project Humanoid Path Planner";
    homepage = "https://github.com/humanoid-path-planner/hpp-doc";
    changelog = "https://github.com/humanoid-path-planner/hpp-doc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
