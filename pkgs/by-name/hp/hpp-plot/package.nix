{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  fetchNpmDeps,
  nodejs,
  npmHooks,
  python3Packages,

  # buildInputs
  jrl-cmakemodules,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-plot";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-plot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LSneHIYHwFT0DYFY/mS8AulXAPzlWn5csH+AWM7podA=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs ++ [
    python3Packages.python
    npmHooks.npmConfigHook
    nodejs
  ];

  buildInputs = [
    jrl-cmakemodules
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
    (lib.cmakeBool "USE_JS" false) # build from nix not cmake
  ];

  postPatch = ''
    # prepare npm offline cache
    mkdir -p node_modules
    cd src/web_app
    cp package.json package-lock.json ../..
    ln -s ../../node_modules
    cd -
  '';

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    src = finalAttrs.src + "/src/web_app/";
    hash = "sha256-GAYdugZFMygk0MXyXxf2wSsWRvn/aW4YeFH2v62IZjI=";
  };
  preBuild = ''
    cd ../src/web_app
    npm --offline run build
    cd -
  '';
  postInstall = ''
    cp -r ../src/web_app/dist $out/share/hpp-plot/webapp
  '';

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Graphical utilities for constraint graphs in hpp-manipulation";
    homepage = "https://github.com/humanoid-path-planner/hpp-plot";
    changelog = "https://github.com/humanoid-path-planner/hpp-plot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
