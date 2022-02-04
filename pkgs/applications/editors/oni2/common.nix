{ lib, stdenv, nodePackages
# Fetch dependencies
, fetchFromGitHub, gitMinimal, curlMinimal, cacert, yarn, unzip, xorg, nodejs
, ripgrep, fontconfig, libGL, libGLU, ncurses, acl, harfbuzz, libjpeg, expat
, icu58, libpng
# Build
, jq, perl, makeWrapper, bash, which, nasm, python2, gn, ninja, cmake, clang
, fixup_yarn_lock, callPackage }:

{ variant, version, rev, sha256, fetchDepsSha256, license }:

let
  source = fetchFromGitHub {
    repo = variant;
    owner = "onivim";
    inherit rev sha256;
  };

  fetchDeps = stdenv.mkDerivation {
    name = "oni2-fetch-deps";

    unpackPhase = ''
      cp ${source}/{release,package}.json ./
      cp -r ${source}/{release.esy.lock,node,extensions} ./
      chmod -R +w node extensions
    '';

    nativeBuildInputs = [
      jq
      nodePackages.esy
      gitMinimal
      curlMinimal
      cacert
      python2
      perl
      unzip
      yarn
    ];

    buildPhase = ''
      export ESY__PREFIX=$NIX_BUILD_TOP/esy
      export ESY__GLOBAL_PATH=PATH

      esy '@release' install

      ln -s $NIX_BUILD_TOP/esy/source/i/ $NIX_BUILD_TOP/source

      cd $NIX_BUILD_TOP/source
      cd $(ls | grep "^esy_skia")

      # Prefetch esy_skia pinned dependencies
      # angle2, dng_sdk, piex and sfntly are unique and need to be fetched
      # zlib and webp used here seem to be outdated, so it's impossible to link esy_skia against upstream zlib and webp
      cat DEPS | grep -E '{|}|angle2|dng_sdk|piex|sfntly|zlib|webp' > DEPS-upd
      mv DEPS{-upd,}
      python tools/git-sync-deps
      # Patch esy_skia builder to use nixpkgs ninja, gn tools and icu, expat and libpng libraries.
      cd esy
      patch build.sh ${./esy_skia_use_nixpkgs.patch}

      cd $NIX_BUILD_TOP/source
      cd $(ls | grep '^revery' | grep -v '__s__')
      jq '.esy.build |= "bash -c \"\(.)\""' package.json > package-upd.json
      mv package{-upd,}.json

      # Delete esy_cmake and ninja dependencies (they are brought from Nixpkgs)
      # Removing them from release.esy.lock is hard because it reports corruption
      for d in "revery__s__esy_cmake" "ninja"; do
        cd $NIX_BUILD_TOP/source
        cd $(ls | grep $d)
        rm -rf *
      done

      rm -rf $(find $NIX_BUILD_TOP/esy -name .git)
    '';

    installPhase = ''
      mkdir $out
      cp -r $NIX_BUILD_TOP/esy $out/
    '';

    dontPatchShebangs = true;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars;

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = fetchDepsSha256;
  };
in stdenv.mkDerivation (rec {
  pname = "oni2";
  inherit version;

  nativeBuildInputs = [
    clang
    makeWrapper
    nodePackages.esy
    bash
    perl
    which
    nasm
    python2
    gn
    ninja
    cmake
    jq
    yarn
    fixup_yarn_lock
  ];

  buildInputs = [
    nodejs
    ripgrep
    fontconfig
    libGL
    libGLU
    ncurses
    acl
    harfbuzz
    libjpeg
    expat
    icu58
    libpng
  ] ++ (with xorg; [
    libX11
    libXext
    libXi
    libXxf86vm
    libXrandr
    libXinerama
    libXcursor
    libICE
    libSM
    libXt
    libxkbfile
  ]);

  unpackPhase = ''
    cp -r ${source}/* ./
    cp -r ${fetchDeps}/esy ./

    chmod -R +w esy node/ extensions/
    chmod +w assets/configuration
  '';

  hardeningDisable = [ "fortify" ];

  node = (callPackage ./node.nix { }).offline_cache;
  extensions = (callPackage ./extensions.nix { }).offline_cache;

  configurePhase = ''
    runHook preConfigure

    # Esy by default erases the entire environment, so the builder makes a wrapper over bash to automatically re-export it
    mkdir wrapped-bash
    echo "#!${bash}/bin/bash" > wrapped-bash/bash
    export | sed 's/PATH="/PATH="$PATH:/' >> wrapped-bash/bash
    echo "exec ${bash}/bin/bash \"\$@\"" >> wrapped-bash/bash
    chmod +x wrapped-bash/bash

    # Use custom builder for Oni2 to provide necessary environment to it
    echo 'declare -x NIX_LDFLAGS="$NIX_LDFLAGS -lXext -lharfbuzz -ljpeg -lpthread -lpng -lexpat"' > build.sh
    echo $(jq -r '.esy.build' package.json) >> build.sh
    jq '.esy.build |= "bash build.sh"' package.json > package-upd.json
    mv package{-upd,}.json

    export PATH="$NIX_BUILD_TOP/wrapped-bash:$PATH"
    patchShebangs $NIX_BUILD_TOP/esy/source

    echo "" > assets/configuration/setup.json # it will be set at installation phase.

    substituteInPlace src/gen_buildinfo/generator.re --replace "git rev-parse --short HEAD" "echo '${version}'"

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Required by yarn
    export HOME=$(mktemp -d)

    # Install pinned yarn packages
    yarnInstall() {
      # Remove `resolutions` section from package.json
      jq 'del(.resolutions)' $3/package.json > $3/package-upd.json
      cp $3/package{-upd,}.json

      # Copy custom yarn.lock to match updated package.json, do fixup
      cp $2 $3/yarn.lock
      fixup_yarn_lock $3/yarn.lock

    # Make yarn install prefetched dependencies
     yarn config --offline set yarn-offline-mirror $1
     # Set explicit node install directory for node-gyp.
     npm_config_nodedir=${nodejs} yarn install --frozen-lockfile --offline --no-progress --non-interactive --cwd $3
    }
    yarnInstall ${node} ${./node.lock} node
    yarnInstall ${extensions} ${./extensions.lock} extensions

    export ESY__PREFIX="$NIX_BUILD_TOP/esy"
    esy '@release' install # should do nothing

    export ESY__GLOBAL_PATH=PATH
    # Create link to bin directory, currently empty
    esy '@release' sh -c "ln -s \$cur__bin result"
    # Finish building Oni2
    esy '@release' x Oni2 --help

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out

    cp -Lr ./result $out/bin
    cp -r ./node $out/
    cp -r ./extensions $out/

    chmod +w $out/bin
    chmod +x $out/bin/Oni2 $out/bin/Oni2_editor
    # Unset LANG and XMODIFIERS. See https://github.com/onivim/oni2/issues/3772
    # Unset SDL_VIDEODRIVER because Wayland is not supported. See https://github.com/onivim/oni2/issues/3438
    mv $out/bin/Oni2{,_unwrapped}
    makeWrapper $out/bin/Oni2{_unwrapped,} --unset LANG --unset XMODIFIERS --unset SDL_VIDEODRIVER
    mv $out/bin/Oni2_editor{,_unwrapped}
    makeWrapper $out/bin/Oni2_editor{_unwrapped,} --unset LANG --unset XMODIFIERS --unset SDL_VIDEODRIVER

    rm -f $out/bin/setup.json
    jq -n "{node: \"${nodejs}/bin/node\", nodeScript: \"$out/node\", bundledExtensions: \"$out/extensions\", rg: \"${ripgrep}/bin/rg\"}" > $out/bin/setup.json

    mkdir -p $out/share/applications $out/share/pixmaps
    cp ${source}/scripts/linux/Onivim2.desktop $out/share/applications
    cp ${source}/assets/images/icon512.png $out/share/pixmaps/Onivim2.png

    runHook postInstall
  '';

  meta = with lib; {
    description = "Native, lightweight modal code editor";
    longDescription = ''
      Onivim 2 is a reimagination of the Oni editor. Onivim 2 aims to bring the speed of Sublime, the language integration of VSCode, and the modal editing experience of Vim together, in a single package.
    '';
    homepage = "https://v2.onivim.io/";
    inherit license;
    maintainers = with maintainers; [ gardspirito ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
})

