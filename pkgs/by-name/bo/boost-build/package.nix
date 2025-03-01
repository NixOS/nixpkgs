{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  # boost derivation to use for the src and version.
  # This is used by the boost derivation to build
  # a b2 matching their version (by overriding this
  # argument). Infinite recursion is not an issue
  # since we only look at src and version of boost.
  useBoost ? { },
}:

let
  defaultVersion = "4.4.1";
in

stdenv.mkDerivation {
  pname = "boost-build";
  version = if useBoost ? version then "boost-${useBoost.version}" else defaultVersion;

  src =
    useBoost.src or (fetchFromGitHub {
      owner = "boostorg";
      repo = "build";
      rev = defaultVersion;
      sha256 = "1r4rwlq87ydmsdqrik4ly5iai796qalvw7603mridg2nwcbbnf54";
    });

  # b2 is in a subdirectory of boost source tarballs
  postUnpack = lib.optionalString (useBoost ? src) ''
    sourceRoot="$sourceRoot/tools/build"
  '';

  patches =
    useBoost.boostBuildPatches or [ ]
    ++ lib.optional (
      useBoost ? version && lib.versionAtLeast useBoost.version "1.81"
    ) ./fix-clang-target.patch;

  postPatch =
    lib.optionalString (useBoost ? version && lib.versionAtLeast useBoost.version "1.80") ''
      # Upstream uses arm64, but nixpkgs uses aarch64.
      substituteInPlace src/tools/clang.jam \
        --replace-fail 'arch = arm64' 'arch = aarch64'
    ''
    + lib.optionalString (useBoost ? version && lib.versionOlder useBoost.version "1.77") ''
      substituteInPlace src/build-system.jam \
        --replace-fail "default-toolset = darwin" "default-toolset = clang-darwin"
    ''
    + lib.optionalString (useBoost ? version && lib.versionAtLeast useBoost.version "1.82") ''
      patchShebangs --build src/engine/build.sh
    '';

  nativeBuildInputs = [
    bison
  ];

  buildPhase = ''
    runHook preBuild
    ./bootstrap.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ./b2 ${lib.optionalString (stdenv.cc.isClang) "toolset=clang "}install --prefix="$out"

    # older versions of b2 created this symlink,
    # which we want to support building via useBoost.
    test -e "$out/bin/bjam" || ln -s b2 "$out/bin/bjam"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.boost.org/build/";
    license = lib.licenses.boost;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ivan-tkatchev ];
  };
}
