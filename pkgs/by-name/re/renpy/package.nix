{
  lib,
  stdenv,
  assimp,
  copyDesktopItems,
  desktopToDarwinBundle,
  fetchFromGitHub,
  fetchurl,
  fetchzip,
  ffmpeg,
  freetype,
  fribidi,
  glew,
  harfbuzz,
  libGL,
  libGLU,
  libjpeg,
  libpng,
  makeBinaryWrapper,
  makeDesktopItem,
  openssl,
  pkg-config,
  python312,
  SDL2,
  SDL2_image,
  versionCheckHook,
  zenity,
  zlib,

  # the minimal package contains only compiled python and cython files, and the example projects and the launcher are removed
  # one should use the minimal package in favor of the full package when packaging games, in which case only the game runtime is needed
  minimal ? false,
  # with this, you can click "Documentation" in the launcher to open local doc (otherwise it opens web doc)
  withDoc ? !minimal,
  # set this to true if you want to use this package to distribute games
  # (to windows, linux, and macos, outside of nix; android, ios, and web are not supported)
  withDistributedLibs ? !minimal,
  # set this to true if you additionally want to distribute games for aarch64-linux
  # this implies withDistributedLibs = true because it also includes the libraries for other platforms
  withAarch64LinuxDistributedLibs ?
    withDistributedLibs && stdenv.targetPlatform.isAarch64 && stdenv.targetPlatform.isLinux,
}:

# technically we can support cross-compilation by first compiling a renpy for the build platform besides a renpy for the host platform
# and we can use the former to compile the rpy{,m} files but install the latter to $out
# but let's not bother
assert lib.assertMsg (stdenv.buildPlatform.canExecute stdenv.hostPlatform)
  "Ren'Py cannot be cross-compiled because it needs to run itself during the build phase.";

assert lib.assertMsg (!minimal || !withDistributedLibs && !withAarch64LinuxDistributedLibs)
  "The distributed libraries are only useful when used with the Ren'Py launcher, which is not installed for the minimal Ren'Py package.";

let
  pythonBuildTime = python312.withPackages (
    ps:
    with ps;
    [
      cython
      setuptools
      pkgconfig

      # the runtime dependencies are also added to compile bundled rpy{,m} files in renpy source tree
      future
      pefile
      requests
      rsa
      six
    ]
    ++ lib.optionals withDoc [
      sphinx
      sphinx-rtd-theme
      sphinx-rtd-dark-mode
    ]
  );
  pythonRunTime = python312.withPackages (
    ps: with ps; [
      future
      pefile
      requests
      rsa
      six
    ]
  );

in
stdenv.mkDerivation (finalAttrs: {
  pname = "renpy";
  # unstable version drops dependency on insecure package ecdsa
  version = "8.5.2.26010301";

  src = fetchFromGitHub {
    owner = "renpy";
    repo = "renpy";
    rev = "09eb6986ea9e5dbe64c9096ed48a638e593ea0ef";
    hash = "sha256-w7tQbZCH7F0Npu8rD2UADxe/KzsTUdtIhJY6GH4YFAs=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    pythonBuildTime
  ]
  ++ lib.optional (!minimal) copyDesktopItems
  ++ lib.optional (stdenv.hostPlatform.isDarwin && !minimal) desktopToDarwinBundle;

  buildInputs = [
    assimp
    ffmpeg
    freetype
    fribidi
    glew
    harfbuzz
    libGL
    libGLU
    libjpeg
    openssl
    SDL2
    SDL2_image
    pythonRunTime
  ];

  enableParallelBuilding = true;

  patches = [
    # do not try to compile renpy files installed in nix store because we already compiled them at build phase
    ./dont-compile-system.patch

    # catch error instead of crashing when trying to write steam_appid.txt to nix store
    # https://github.com/renpy/renpy/pull/6976
    ./steam-preinit-catch.patch

    # fix write_target looking for wrong file locations when launcher creates new project
    # https://github.com/renpy/renpy/pull/6978
    ./new-project-prefix.patch

    # the distributed libs are not compatible with renpy built from source,
    # so patch the launcher to look for renpy files in renpy-dist (where bin distribution from upstream is copied to) instead of renpy
    ./distribute.patch
  ];

  postPatch = ''
    # use nix out path instead of `renpy.config.renpy_base` because otherwise we cannot compile them in the build phase
    substituteInPlace renpy/script.py --replace-fail "@systemRenpy@" "$out/share/renpy"

    patchShebangs --build setup.py

    # https://github.com/renpy/renpy/blob/8.5.2.26010301/tutorial/game/01director_support.rpy
    cp tutorial/game/tutorial_director.rpy{m,}

    cat > renpy/vc_version.py << EOF
    branch = 'master'
    version = '${finalAttrs.passthru.appver}'
    official = False
    nightly = False
    # Look at https://renpy.org/latest.html for what to put.
    version_name = "In Good Health"
    EOF
  '';

  env.PYTHONDONTWRITEBYTECODE = "1";

  buildPhase = ''
    runHook preBuild

    ./setup.py build_ext --inplace -j $NIX_BUILD_CORES

    # so that these files won't need to be compiled on the host platform
    python -m compileall renpy -q -d renpy -f${lib.optionalString minimal " -b"};

    ${lib.optionalString (!minimal) ''
      # compile bundled rpy{,m} files so that they don't have to be compiled when used on the host platform
      python renpy.py gui compile
      python renpy.py tutorial compile
      python renpy.py the_question compile
    ''}

    # there is no single command to compile all rpym files, so apply a temporary patch for doing that
    patch -p1 -i ${./temp-compile-modules.patch}
    python renpy.py . compile
    patch -p1 -R -i ${./temp-compile-modules.patch}

    ${lib.optionalString (!minimal) "rm -r {tutorial,the_question}/game/saves"}

    ${lib.optionalString withDoc ''
      # https://github.com/renpy/renpy/blob/8.5.2.26010301/sphinx/build.sh
      pushd sphinx
      mkdir -p source/inc
      python ../renpy.py .
      RENPY_NO_FIGURES=1 sphinx-build -E -a source ../doc
      popd
    ''}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ./setup.py install_lib -d $out/share/renpy
    cp -ar renpy renpy.py $out/share/renpy

    makeWrapper ${lib.getExe pythonRunTime} $out/bin/renpy --add-flags "$out/share/renpy/renpy.py" ${
      # add zenity for file dialogs (https://github.com/renpy/renpy/blob/8.5.2.26010301/src/tinyfiledialogs/tinyfiledialogs.c#L188)
      lib.optionalString (!minimal) "--prefix PATH : ${lib.makeBinPath [ zenity ]}"
    }

    ${lib.optionalString minimal ''
      # delete files not necessary at runtime
      find $out/share/renpy/renpy -type f -regextype posix-egrep -regex '.*\.(py|pyx|pyd|pxd|pyi|pxi|rpy|rpym)$' -delete
    ''}

    ${lib.optionalString (!minimal) ''
      cp -ar sdk-fonts gui launcher the_question tutorial $out/share/renpy

      # most commands (such as `distribute`) are commands of the launcher but not renpy itself
      makeWrapper $out/bin/renpy $out/bin/renpy-launcher --add-flags "$out/share/renpy/launcher"

      mkdir -p $out/share/icons/hicolor/{256x256,32x32}/apps
      ln -s $out/share/renpy/launcher/game/images/window-icon.png $out/share/icons/hicolor/256x256/apps/renpy.png
      ln -s $out/share/renpy/launcher/game/images/logo32.png $out/share/icons/hicolor/32x32/apps/renpy.png
    ''}

    ${lib.optionalString withDoc "cp -ar doc $out/share/renpy"}

    ${lib.optionalString (finalAttrs.passthru.distributedRenpy != null) ''
      # have to use cp instead of symlinkJoin because renpy resolves symlinks to find its base dir
      cp -ar ${finalAttrs.passthru.distributedRenpy}/{update,lib,renpy.sh} $out/share/renpy
      # renpy packaged from source in this nix package is not compatible with the distributed libs
      cp -ar ${finalAttrs.passthru.distributedRenpy}/renpy $out/share/renpy/renpy-dist
    ''}

    runHook postInstall
  '';

  desktopItems = lib.optional (!minimal) (makeDesktopItem {
    name = "renpy";
    desktopName = "Ren'Py";
    comment = finalAttrs.meta.description;
    exec = "renpy-launcher %U";
    icon = "renpy";
    categories = [ "Development" ];
  });

  # keep the files in $out/share/renpy/{renpy-dist,lib,renpy.sh} redistributable
  dontStrip = true;
  dontPatchShebangs = true;
  dontPatchELF = true;
  postFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    patchELF $out/share/renpy/renpy
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = false; # set to true when the version is not unstable

  passthru = {
    appver = lib.head (builtins.match "([0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+).*" finalAttrs.version);
    semver = lib.head (builtins.match "([0-9]+\\.[0-9]+\\.[0-9]+).*" finalAttrs.version);

    binSrc = fetchzip {
      url = "https://www.renpy.org/dl/${finalAttrs.passthru.semver}/renpy-${finalAttrs.passthru.semver}-sdk.tar.bz2";
      hash = "sha256-wF6Z/lA8CyaCEZg1IqpZ4mG8CF8JgNHBf5KjKIOoKVI=";
    };

    binSrcArm = fetchzip {
      url = "https://www.renpy.org/dl/${finalAttrs.passthru.semver}/renpy-${finalAttrs.passthru.semver}-sdkarm.tar.bz2";
      hash = "sha256-DKXghs1XIRrtAGTifMx+7XAbxiqH7qYQiaKhBaO7PBA=";
    };

    distributedRenpy =
      if withAarch64LinuxDistributedLibs then
        finalAttrs.passthru.binSrcArm
      else if withDistributedLibs then
        finalAttrs.passthru.binSrc
      else
        null;

    updateScript = ./update.sh;
  };

  meta = {
    description = "Visual Novel Engine";
    mainProgram = "renpy";
    homepage = "https://renpy.org/";
    changelog = "https://renpy.org/doc/html/changelog.html";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      shadowrz
      ulysseszhan
    ];
    sourceProvenance =
      with lib.sourceTypes;
      [ fromSource ]
      ++ lib.optionals (finalAttrs.passthru.distributedRenpy != null) [
        binaryNativeCode # bundled python for windows, linux, and macos in the bin distribution from upstream
        binaryBytecode # __pycache__ in the bin distribution from upstream
      ];
  };
})
