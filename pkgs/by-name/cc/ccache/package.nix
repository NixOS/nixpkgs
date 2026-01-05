{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  binutils,
  asciidoctor,
  cmake,
  perl,
  fmt,
  hiredis,
  xxHash,
  zstd,
  bashInteractive,
  doctest,
  xcodebuild,
  makeWrapper,
  ctestCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ccache";
  version = "4.12.2";

  src = fetchFromGitHub {
    owner = "ccache";
    repo = "ccache";
    tag = "v${finalAttrs.version}";
    # `git archive` replaces `$Format:%H %D$` in cmake/CcacheVersion.cmake
    # we need to replace it with something reproducible
    # see https://github.com/NixOS/nixpkgs/pull/316524
    postFetch = ''
      sed -i -E \
        's/version_info "([0-9a-f]{40}) .*(tag: v[^,]+).*"/version_info "\1 \2"/g w match' \
        $out/cmake/CcacheVersion.cmake
      if [ -s match ]; then
        rm match
      else # pattern didn't match
        exit 1
      fi
    '';
    hash = "sha256-oWzVCrNgYtOeN4+KJmIynT3jiFZfxrsLkoIm0lK3MBo=";
  };

  outputs = [
    "out"
    "man"
  ];

  patches = [
    # When building for Darwin, test/run uses dwarfdump, whereas on
    # Linux it uses objdump. We don't have dwarfdump packaged for
    # Darwin, so this patch updates the test to also use objdump on
    # Darwin.
    # Additionally, when cross compiling, the correct target prefix
    # needs to be set.
    (replaceVars ./fix-objdump-path.patch {
      objdump = "${binutils.bintools}/bin/${binutils.targetPrefix}objdump";
    })
  ];

  postPatch = ''
    patchShebangs --build test/fake-compilers
  '';

  strictDeps = true;

  nativeBuildInputs = [
    asciidoctor
    cmake
    perl
  ];

  buildInputs = [
    fmt
    hiredis
    xxHash
    zstd
  ];

  cmakeFlags = lib.optional (!finalAttrs.finalPackage.doCheck) "-DENABLE_TESTING=OFF";

  doCheck = true;

  nativeCheckInputs = [
    # test/run requires the compgen function which is available in
    # bashInteractive, but not bash.
    bashInteractive
    ctestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin xcodebuild;

  checkInputs = [
    doctest
  ];

  disabledTests = [
    "test.trim_dir" # flaky on hydra (possibly filesystem-specific?)
    "test.fileclone" # flaky on hydra, also seems to fail on zfs
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test.basedir"
    "test.multi_arch"
    "test.nocpp2"
  ];

  passthru = {
    # A derivation that provides gcc and g++ commands, but that
    # will end up calling ccache for the given cacheDir
    links =
      { unwrappedCC, extraConfig }:
      stdenv.mkDerivation {
        pname = "ccache-links";
        inherit (finalAttrs) version;
        passthru = {
          isClang = unwrappedCC.isClang or false;
          isGNU = unwrappedCC.isGNU or false;
          isCcache = true;
        };
        lib = lib.getLib unwrappedCC;
        nativeBuildInputs = [ makeWrapper ];
        # Unwrapped clang does not have a targetPrefix because it is multi-target
        # target is decided with argv0.
        buildCommand =
          let
            targetPrefix =
              if unwrappedCC.isClang or false then
                ""
              else
                (lib.optionalString (
                  unwrappedCC ? targetConfig && unwrappedCC.targetConfig != null && unwrappedCC.targetConfig != ""
                ) "${unwrappedCC.targetConfig}-");
          in
          ''
            mkdir -p $out/bin

            wrap() {
              local cname="${targetPrefix}$1"
              if [ -x "${unwrappedCC}/bin/$cname" ]; then
                makeWrapper ${finalAttrs.finalPackage}/bin/ccache $out/bin/$cname \
                  --run ${lib.escapeShellArg extraConfig} \
                  --add-flags ${unwrappedCC}/bin/$cname
              fi
            }

            wrap cc
            wrap c++
            wrap gcc
            wrap g++
            wrap clang
            wrap clang++

            for executable in $(ls ${unwrappedCC}/bin); do
              if [ ! -x "$out/bin/$executable" ]; then
                ln -s ${unwrappedCC}/bin/$executable $out/bin/$executable
              fi
            done
            for file in $(ls ${unwrappedCC} | grep -vw bin); do
              ln -s ${unwrappedCC}/$file $out/$file
            done
          '';

        meta = {
          inherit (unwrappedCC.meta) mainProgram;
        };
      };

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Compiler cache for fast recompilation of C/C++ code";
    homepage = "https://ccache.dev";
    downloadPage = "https://ccache.dev/download.html";
    changelog = "https://ccache.dev/releasenotes.html#_ccache_${
      builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      kira-bruneau
      r-burns
    ];
    platforms = platforms.unix;
    mainProgram = "ccache";
  };
})
