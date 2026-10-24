{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  fetchgit,
  makeWrapper,
  fetchFromGitHub,
  dpkg,
  glib,
  gnutar,
  gtk3-x11,
  luajit,
  sdcv,
  sdl3,
  openssl,
  writeScript,
  # darwin source build (koreader-base has no prebuilt binary for darwin)
  autoconf,
  automake,
  cmake,
  curl,
  flock,
  gcc,
  gettext,
  git,
  gnumake,
  libtool,
  meson,
  nasm,
  ninja,
  perl,
  pkg-config,
  python3,
  unzip,
  # darwin: nixpkgs packages substituted in place of a handful of koreader-base's
  # vendored thirdparty deps that are just unpatched copies of these; see
  # thirdparty-sources.nix.
  coreutils,
  zlib,
  sqlite,
  utf8proc,
  xxhash,
  cacert,
  luajitPackages,
}:

let
  version = "2026.07.1";

  # LuaJIT with table.pack/unpack support for KOReader
  # https://github.com/koreader/koreader-base/tree/master/thirdparty/luajit
  luajit_koreader = luajit.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (fetchpatch {
        url = "https://raw.githubusercontent.com/koreader/koreader-base/master/thirdparty/luajit/koreader-luajit-enable-table_pack.patch";
        hash = "sha256-tvx7eRoSwnumqK6H7+2RCAKRDFJtaRY/2mRPjy30fJA=";
      })
    ];
  });

  src_repo = fetchFromGitHub {
    repo = "koreader";
    owner = "koreader";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-395G5bu0gs0oKOc/CfKNeal66vgXBDgHSpopoQ0GRzw=";
  };

  # koreader-base vendors ~60 thirdparty C/C++ libraries (mupdf, freetype, sdl3,
  # luajit, crengine, ...) that its own build system fetches from the network
  # mid-build. There's no prebuilt binary for darwin, so we build from source,
  # which means these need to be pinned and pre-supplied offline instead; see
  # thirdparty-sources.nix.
  thirdpartySources = import ./thirdparty-sources.nix { inherit fetchurl fetchgit; };

  # Populate koreader-base's per-package download cache (`<pkg>/build/downloads/...`)
  # so its `download_archive` / `clone_git_repo` helpers
  # (base/thirdparty/cmake_modules/koenv.sh) see already-present, correctly-hashed
  # sources and skip their network fetch entirely.
  populateThirdpartyCache =
    lib.concatStrings (
      lib.mapAttrsToList (name: dep: ''
        mkdir -p "base/thirdparty/${name}/build/downloads"
        ln -sf ${dep.src} "base/thirdparty/${name}/build/downloads/${dep.file}"
      '') thirdpartySources.url
    )
    + lib.concatStrings (
      lib.mapAttrsToList (name: src: ''
        mkdir -p "base/thirdparty/${name}/build/downloads"
        rm -rf "base/thirdparty/${name}/build/downloads/source"
        cp -a ${src} "base/thirdparty/${name}/build/downloads/source"
        chmod -R u+w "base/thirdparty/${name}/build/downloads/source"
      '') thirdpartySources.git
    );

  # koreader-base's own recipes for zlib/sqlite/utf8proc/xxhash/certifi/dkjson (see
  # thirdparty-sources.nix) just build a vanilla, unpatched copy of a library nixpkgs
  # already ships. Skip building them from source entirely, and instead overwrite
  # their `base/thirdparty/<name>/CMakeLists.txt` with a stub whose `external_project()`
  # "install" step (base/thirdparty/cmake_modules/koreader_external_project.cmake) just
  # deposits nixpkgs' own build output where the sysroot other thirdparty recipes'
  # `declare_dependency()` calls expect it: `$STAGING_DIR/include` + `$STAGING_DIR/lib`
  # (STAGING_DIR = $OUTPUT_DIR/staging per base/Makefile.defs) for libraries, or
  # `$OUTPUT_DIR/<path>` directly for standalone data/script files. `external_project()`
  # with no DOWNLOAD/BUILD_COMMAND makes every other step a no-op, so this is safe even
  # though the generic machinery still wires up the download/prepare/configure/build/
  # install custom targets `setup_project()` expects to already exist.
  #
  # Depending on koreader-base's `MONOLIBTIC` flag (base/Makefile.defs), a given
  # consumer's `declare_dependency(... MONOLIBTIC <lib>)` call in
  # base/thirdparty/cmake_modules/koreader_thirdparty_libs.cmake resolves to
  # either `$STAGING_DIR/lib/lib<lib>.a` (static) or `$STAGING_DIR/lib/lib<lib>$LIB_EXT`
  # (shared, unversioned) -- and it's not a single build-wide constant: e.g.
  # `sdcv`'s own recipe picks its zlib form independently of MONOLIBTIC's effect on
  # `declare_dependency`. Rather than track down which of the two any given
  # consumer wants, `vendorStaticLib` below just deposits both forms, so nixpkgs'
  # static and shared builds of each of these are both made available.
  sqlite-static = sqlite.overrideAttrs (old: {
    dontDisableStatic = true;
  });
  utf8proc-static = utf8proc.override { enableStatic = true; };
  xxhash-static = xxhash.overrideAttrs (old: {
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [ (lib.cmakeBool "BUILD_SHARED_LIBS" false) ];
  });

  # `external_project()`'s "build" step always runs with `WORKING_DIRECTORY
  # ${BINARY_DIR}`, and that directory only gets created as a side effect of
  # having a real BUILD_COMMAND/CMAKE_ARGS/CONFIGURE_COMMAND (see the
  # `if(CMD OR _BUILD_COMMAND) ... mkdir -p ${BINARY_DIR}` prepend in its
  # "configure" step, in koreader_external_project.cmake). Passing only
  # INSTALL_COMMAND leaves that directory never created, so every stub below
  # also passes this trivial always-succeeding BUILD_COMMAND purely to trigger
  # that side effect.
  # (two variants: one for stub files written via a quoted heredoc, where
  # `''${CMAKE_COMMAND}` reaches the file literally; one for `vendorLuaFile`'s
  # unquoted heredoc, which needs the `$` backslash-escaped or bash would try
  # to expand it as its own (nonexistent) variable when the heredoc is read)
  noopBuild = "BUILD_COMMAND COMMAND \${CMAKE_COMMAND} -E echo";
  noopBuildEscaped = ''BUILD_COMMAND COMMAND \''${CMAKE_COMMAND} -E echo'';

  # `soVersion` matches what the original (pre-swap) recipe passed as
  # `append_shared_lib_install_commands(INSTALL_CMD <libName> VERSION <soVersion>)`
  # -- besides feeding $STAGING_DIR for other thirdparty deps to build/link
  # against, that call's real job is copying a *versioned* runtime dylib
  # (`lib<libName>.<soVersion>.dylib`) into $OUTPUT_DIR/libs, which is what
  # koreader's own Lua FFI bindings (base/ffi/*.lua's `ffi.load()`, following
  # base/Makefile.defs' `lib_version_format = lib%s.%s.dylib`) actually dlopen
  # at runtime -- so it has to be reproduced here too, not just the build-time
  # $STAGING_DIR half.
  vendorStaticLib = name: devOut: headers: libName: soVersion: staticLibOut: sharedLibOut: ''
    shared_lib="$(find ${sharedLibOut}/lib -name 'lib${libName}.*${
      if stdenv.hostPlatform.isDarwin then ".dylib" else ".so.*"
    }' ! -type l | head -n1)"
    cat > base/thirdparty/${name}/CMakeLists.txt <<KOEOF
    list(APPEND INSTALL_CMD COMMAND \''${CMAKE_COMMAND} -E make_directory "\''${STAGING_DIR}/include" "\''${STAGING_DIR}/lib" "\''${OUTPUT_DIR}/libs")
    list(APPEND INSTALL_CMD COMMAND \''${CMAKE_COMMAND} -E copy_if_different ${
      lib.concatMapStringsSep " " (h: "${devOut}/include/${h}") headers
    } "\''${STAGING_DIR}/include/")
    list(APPEND INSTALL_CMD COMMAND \''${CMAKE_COMMAND} -E copy_if_different "${staticLibOut}/lib/lib${libName}.a" "\''${STAGING_DIR}/lib/")
    list(APPEND INSTALL_CMD COMMAND \''${CMAKE_COMMAND} -E copy_if_different "$shared_lib" "\''${STAGING_DIR}/lib/lib${libName}\''${LIB_EXT}")
    list(APPEND INSTALL_CMD COMMAND \''${CMAKE_COMMAND} -E copy_if_different "$shared_lib" "\''${STAGING_DIR}/lib/lib${libName}.${soVersion}\''${LIB_EXT}")
    list(APPEND INSTALL_CMD COMMAND \''${CMAKE_COMMAND} -E copy_if_different "$shared_lib" "\''${OUTPUT_DIR}/libs/lib${libName}.${soVersion}\''${LIB_EXT}")
    external_project(${noopBuildEscaped} INSTALL_COMMAND \''${INSTALL_CMD})
    KOEOF
  '';

  vendorDataFile = name: srcFile: destRelPath: ''
    cat > base/thirdparty/${name}/CMakeLists.txt <<'KOEOF'
    list(APPEND INSTALL_CMD COMMAND ''${CMAKE_COMMAND} -E copy_if_different ${srcFile} ''${OUTPUT_DIR}/${destRelPath})
    external_project(${noopBuild} INSTALL_COMMAND ''${INSTALL_CMD})
    KOEOF
  '';

  # dkjson's install path is version-subdirectoried by nixpkgs' Lua build (e.g.
  # share/lua/5.1/dkjson.lua); rather than guess it, resolve it with `find` when
  # this postPatch snippet actually runs.
  vendorLuaFile = name: pkg: fileName: destRelPath: ''
    cat > base/thirdparty/${name}/CMakeLists.txt <<KOEOF
    list(APPEND INSTALL_CMD COMMAND \''${CMAKE_COMMAND} -E copy_if_different "$(find ${pkg} -name ${fileName})" "\''${OUTPUT_DIR}/${destRelPath}")
    external_project(${noopBuildEscaped} INSTALL_COMMAND \''${INSTALL_CMD})
    KOEOF
  '';

  populateVendoredThirdparty = lib.concatStrings [
    (vendorStaticLib "zlib" "${zlib.dev}" [
      "zlib.h"
      "zconf.h"
    ] "z" "1" "${zlib.static}" "${zlib.out}")
    (vendorStaticLib "sqlite" "${sqlite-static.dev}" [
      "sqlite3.h"
      "sqlite3ext.h"
    ] "sqlite3" "0" "${sqlite-static.out}" "${sqlite-static.out}")
    (vendorStaticLib "utf8proc" "${utf8proc}" [
      "utf8proc.h"
    ] "utf8proc" "3" "${utf8proc-static}" "${utf8proc}")
    (vendorStaticLib "xxhash" "${xxhash}" [ "xxhash.h" ] "xxhash" "0" "${xxhash-static}" "${xxhash}")
    (vendorDataFile "certifi" "${cacert}/etc/ssl/certs/ca-bundle.crt" "data/ca-bundle.crt")
    (vendorLuaFile "dkjson" luajitPackages.dkjson "dkjson.lua" "common/dkjson.lua")
  ];
in
stdenv.mkDerivation {
  pname = "koreader";
  inherit version;

  __structuredAttrs = true;
  strictDeps = true;

  src =
    if stdenv.hostPlatform.isDarwin then
      src_repo
    else
      let
        selectSystem =
          attrs:
          attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
        arch = selectSystem {
          aarch64-linux = "arm64";
          armv7l-linux = "armhf";
          x86_64-linux = "amd64";
        };
      in
      fetchurl {
        url = "https://github.com/koreader/koreader/releases/download/v${version}/koreader_${version}-1_${arch}.deb";
        hash = selectSystem {
          aarch64-linux = "sha256-swwNcmquMjnO31pFNkKZbqU8Kx7Rtwq2ebT12XK8yvQ=";
          armv7l-linux = "sha256-TpMm9smcDff7A4BkWguWuOwDAJXQITk/HGmDgDIRtrw=";
          x86_64-linux = "sha256-CWmnfC7Dy4nVf7diwRvsOvE12W/gkE2235h49Hq0f4k=";
        };
      };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ dpkg ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    autoconf
    automake
    cmake
    curl
    flock
    # koreader-base's `ffi-cdecl` codegen tool builds a real GCC plugin, even
    # though the app itself is built with Clang.
    gcc
    gettext
    git
    gnumake
    libtool
    meson
    nasm
    ninja
    perl
    pkg-config
    python3
    unzip
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib
    gnutar
    gtk3-x11
    luajit_koreader
    sdcv
    sdl3
    openssl
  ];

  # koreader-base's Makefile assumes a Homebrew-style `gln` (GNU coreutils
  # installed with a `g` prefix to avoid clashing with macOS's BSD `ln`).
  # nixpkgs' own `ln` already is GNU coreutils, so just point it there.
  #
  # It also assumes any `CMAKE_HOST_APPLE` build has the real BSD `sed`
  # (`sed -i '' -e ...`), but our sandbox's `sed` is nixpkgs' GNU sed, which
  # parses that differently and fails ("sed: can't read : No such file or
  # directory"). Force the GNU-style invocation it already uses everywhere else.
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # The darwin sandbox has no `/usr/bin/env`; fix koreader-base's own scripts
    # (e.g. utils/gen_linker_exports.sh). Unpacked thirdparty sources are
    # handled separately below.
    patchShebangs base

    substituteInPlace base/Makefile.defs --replace-fail 'SYMLINK = gln' 'SYMLINK = ln'
    substituteInPlace base/thirdparty/cmake_modules/koreader_thirdparty_common.cmake \
      --replace-fail 'if(CMAKE_HOST_APPLE)' 'if(FALSE)'
    # `ld -v` with no input files exits non-zero under nixpkgs' darwin linker
    # (LLD-based, unlike Apple's real ld64 which tolerates this), aborting the
    # script under `set -e` before it ever inspects the version string.
    substituteInPlace base/utils/gen_linker_exports.sh \
      --replace-fail \
        'linker_version="$("''${linker}" -v 2>&1)"' \
        'linker_version="$("''${linker}" -v 2>&1)" || true'
    # The thirdparty sources are unpacked mid-build by `extract_archive` /
    # `checkout_git_repo`, after `patchShebangs` has already had its chance
    # to run, and the darwin sandbox has no `/usr/bin/env` (e.g. harfbuzz's
    # `gen-hb-version.py` then fails to exec with EPERM). Rewrite those
    # shebangs right after each source tree is created.
    # The git sources are pre-fetched with plain `fetchgit` (see
    # thirdparty-sources.nix), i.e. already checked out at the right revision,
    # submodules included, and without a `.git` (keeping `.git` makes the fixed-output
    # hash unreproducible). So skip `clone_git_repo` / `checkout_git_repo`'s git
    # operations, and just use / copy the pre-supplied tree.
    substituteInPlace base/thirdparty/cmake_modules/koenv.sh \
      --replace-fail 'extract_archive() { (' \
        'patch_env_shebangs() {
        grep -rIlZ "^#!/usr/bin/env " "$1" | xargs -0 -r sed -i "1s,^#!/usr/bin/env ,#!${coreutils}/bin/env ,"
    }

    extract_archive() { (' \
      --replace-fail '    mv "''${sourcedir}.tmp/''${root}" "''${sourcedir}"' \
        '    mv "''${sourcedir}.tmp/''${root}" "''${sourcedir}"
        patch_env_shebangs "''${sourcedir}"' \
      --replace-fail '        export GIT_DIR="''${repo}/.git"' \
        '        return 0
      export GIT_DIR="''${repo}/.git"' \
      --replace-fail '    (flock 9 && cp -a "''${repo}" "''${tree}") 9>"''${repo}.lock" || return 1' \
        '    (flock 9 && cp -a "''${repo}" "''${tree}") 9>"''${repo}.lock" || return 1
        patch_env_shebangs "''${tree}"
        return 0'
  '';

  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin (
    populateThirdpartyCache + populateVendoredThirdparty
  );

  # `cmake` and `meson` in nativeBuildInputs otherwise make their setup-hooks install
  # their own default configurePhase (each overriding the previous), running against
  # the repo root -- but koreader's real CMakeLists.txt lives nested under base/cmake/,
  # invoked with its own toolchain flags via `make` (see buildPhase). Let `make` drive
  # its own configure step instead.
  dontUseCmakeConfigure = true;
  dontUseMesonConfigure = true;

  buildPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preBuild

    export HOME=$TMPDIR
    export MACOSX_DEPLOYMENT_TARGET=11.0

    # `VERSION`/`RELEASE_DATE`/`RELEASE_EPOCH` are normally derived via `git describe`
    # / `git log`, which need real git history/tags we don't have (fetchFromGitHub
    # strips `.git`). Overriding them on the `make` command line short-circuits those
    # shell calls entirely (command-line values take precedence over `:=` in the
    # Makefile, so the `$(shell git ...)` right-hand sides are never evaluated).
    make \
      TARGET=macos \
      VERSION=v${version} \
      RELEASE_DATE=1970-01-01 \
      RELEASE_EPOCH=0 \
      -j''${NIX_BUILD_CORES}

    runHook postBuild
  '';

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        runHook preInstall

        # Assemble a macOS .app bundle ourselves, rather than running upstream's
        # `make ... update` + platform/mac/do_mac_bundle.sh verbatim: that pipeline
        # additionally wants `ibtool` (proprietary Xcode Interface Builder, not
        # packageable in nixpkgs) to compile a native menu-bar NIB, plus `7z` /
        # `greadlink` / `gtar` for its self-update archive tooling -- none of which
        # is relevant to a Nix package (Nix handles updates, not koreader's own OTA
        # updater). The app runs fine without the native NIB menu; it just doesn't
        # get a customized macOS menu bar.
        app=$out/Applications/KOReader.app
        mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"

        # -L: koreader's own install step lays out its tree with relative symlinks
        # into the build directory; dereference them so the bundle is self-contained.
        cp -rL koreader-macos-*/koreader "$app/Contents/koreader"

        mv "$app/Contents/koreader/koreader" "$app/Contents/MacOS/koreader"
        mv "$app/Contents/koreader/COPYING" "$app/Contents/koreader/README.md" "$app/Contents/Resources/"
        cp platform/mac/koreader.icns "$app/Contents/Resources/icon.icns"

        # Drop the shebang line and point the "relaunch" reference at the actual
        # bundled executable name, same as do_mac_bundle.sh does.
        sed -e '1d' -e 's,\./reader\.lua,koreader,' \
          "$app/Contents/koreader/reader.lua" >"$app/Contents/koreader/reader.lua.new"
        mv "$app/Contents/koreader/reader.lua.new" "$app/Contents/koreader/reader.lua"
        chmod -x "$app/Contents/koreader/reader.lua"

        printf 'APPL????' >"$app/Contents/PkgInfo"
        cat >"$app/Contents/Info.plist" <<PLIST
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
            <dict>
                <key>CFBundleDevelopmentRegion</key>
                <string>English</string>
                <key>CFBundleName</key>
                <string>KOReader</string>
                <key>CFBundleDisplayName</key>
                <string>KOReader</string>
                <key>CFBundleExecutable</key>
                <string>koreader</string>
                <key>CFBundleIconFile</key>
                <string>icon.icns</string>
                <key>CFBundleIdentifier</key>
                <string>rocks.koreader</string>
                <key>CFBundleShortVersionString</key>
                <string>${version}</string>
                <key>CFBundleInfoDictionaryVersion</key>
                <string>6.0</string>
                <key>CFBundlePackageType</key>
                <string>APPL</string>
                <key>CFBundleSignature</key>
                <string>????</string>
                <key>CFBundleVersion</key>
                <string>1.0</string>
                <key>NSHumanReadableCopyright</key>
                <string>Copyright © KOReader</string>
                <key>NSHighResolutionCapable</key>
                <true/>
                <key>NSPrincipalClass</key>
                <string>NSApplication</string>
                <key>LSMultipleInstancesProhibited</key>
                <true/>
                <key>LSMinimumSystemVersion</key>
                <string>$MACOSX_DEPLOYMENT_TARGET</string>
                <key>SDL_FILESYSTEM_BASE_DIR_TYPE</key>
                <string>bundle</string>
            </dict>
        </plist>
        PLIST

        # (`codesign` isn't available in the sandbox; the individual Mach-O files
        # are ad-hoc signed by the stdenv's autoSignDarwinBinariesHook instead.)

        # koreader's OSX loader refuses to start when invoked through a symlink,
        # so wrap rather than link.
        makeWrapper "$app/Contents/MacOS/koreader" $out/bin/koreader

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        cp --recursive usr $out
      ''
      # Link required binaries
      + ''
        ln -sf ${luajit_koreader}/bin/luajit $out/lib/koreader/luajit
        ln -sf ${sdcv}/bin/sdcv $out/lib/koreader/sdcv
        ln -sf ${gnutar}/bin/tar $out/lib/koreader/tar
      ''
      # Link SSL/network libraries
      + ''
        ln -sf ${lib.getLib openssl}/lib/libcrypto.so.3 $out/lib/koreader/libs/libcrypto.so.1.1
        ln -sf ${lib.getLib openssl}/lib/libssl.so.3 $out/lib/koreader/libs/libssl.so.1.1
        ln -sf ${lib.getLib sdl3}/lib/libSDL3.so.0 $out/lib/koreader/libs/libSDL3.so.0
      ''
      # Copy fonts
      + ''
        cp -r ${src_repo}/resources/fonts/* $out/lib/koreader/fonts/
      ''
      # Remove broken symlinks
      + ''
        find $out -xtype l -print -delete
      ''
      + ''
        wrapProgram $out/bin/koreader --prefix LD_LIBRARY_PATH : $out/lib/koreader/libs:${
          lib.makeLibraryPath [
            gtk3-x11
            sdl3
            glib
            stdenv.cc.cc
            openssl.out
          ]
        }

        runHook postInstall
      '';

  passthru = {
    inherit src_repo luajit_koreader;
    updateScript = writeScript "update-koreader" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix curl jq nix-update common-updater-scripts nix-prefetch-git git python3
      set -eou pipefail
      version=$(nix eval --raw --file . koreader.version)
      nix-update koreader
      latestVersion=$(nix eval --raw --file . koreader.version)
      if [[ "$latestVersion" == "$version" ]]; then
        exit 0
      fi
      update-source-version koreader $latestVersion --source-key=src_repo --ignore-same-version
      systems=$(nix eval --json -f . koreader.meta.platforms | jq --raw-output '.[]')
      for system in $systems; do
        hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix eval --raw -f . koreader.src.url --system "$system")))
        update-source-version koreader $latestVersion $hash --system=$system --ignore-same-version --ignore-same-hash
      done
      # koreader-base's own thirdparty deps (versions, patches, which ones even
      # exist) can and do change on every release -- re-derive our pins from the
      # newly-fetched source tree rather than let them silently go stale. See
      # update-thirdparty-sources.py for what this can't fully automate on its
      # own (needs a human to read its stderr warnings and, occasionally, this
      # package's own postPatch).
      koreaderSrc=$(nix eval --raw -f . koreader.src_repo)
      python3 pkgs/by-name/ko/koreader/update-thirdparty-sources.py \
        "$koreaderSrc" pkgs/by-name/ko/koreader/thirdparty-sources.nix
    '';
  };

  meta = {
    homepage = "https://github.com/koreader/koreader";
    changelog = "https://github.com/koreader/koreader/releases/tag/v${version}";
    description = "Ebook reader application supporting PDF, DjVu, EPUB, FB2 and many more formats, running on Cervantes, Kindle, Kobo, PocketBook and Android devices";
    mainProgram = "koreader";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-linux"
      "armv7l-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      contrun
      liberodark
      sconaway
    ];
  };
}
