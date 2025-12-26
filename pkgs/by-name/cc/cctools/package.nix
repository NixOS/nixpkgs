{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  ld64,
  llvm,
  meson,
  ninja,
  openssl,
  xar,
  gitUpdater,
}:

let
  # The targetPrefix is prepended to binary names to allow multiple binuntils on the PATH to both be usable.
  targetPrefix = lib.optionalString (
    stdenv.targetPlatform != stdenv.hostPlatform
  ) "${stdenv.targetPlatform.config}-";

  # First version with all the required files
  xnu = fetchFromGitHub {
    name = "xnu-src";
    owner = "apple-oss-distributions";
    repo = "xnu";
    rev = "xnu-7195.50.7.100.1";
    hash = "sha256-uHmAOm6k9ZXWfyqHiDSpm+tZqUbERlr6rXSJ4xNACkM=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "${targetPrefix}cctools";
  version = "1010.6";

  outputs = [
    "out"
    "dev"
    "man"
    "gas"
    "libtool"
  ];

  src = fetchFromGitHub {
    owner = "apple-oss-distributions";
    repo = "cctools";
    rev = "cctools-${finalAttrs.version}";
    hash = "sha256-JiKCP6U+xxR4mk4TXWv/mEo9Idg+QQqUYmB/EeRksCE=";
  };

  xcodeHash = "sha256-5RBbGrz1UKV0wt2Uk7RIHdfgWH8sgw/jy7hfTVrtVuM=";

  postUnpack = ''
    unpackFile '${xnu}'

    # Verify that the Xcode project has not changed unexpectedly.
    hashType=$(echo $xcodeHash | cut -d- -f1)
    expectedHash=$(echo $xcodeHash | cut -d- -f2)
    hash=$(openssl "$hashType" -binary "$sourceRoot/cctools.xcodeproj/project.pbxproj" | base64)

    if [ "$hash" != "$expectedHash" ]; then
      echo 'error: hash mismatch in cctools.xcodeproj/project.pbxproj'
      echo "        specified: $xcodeHash"
      echo "           got:    $hashType-$hash"
      echo
      echo 'Upstream Xcode project has changed. Update `meson.build` with any changes, then update `xcodeHash`.'
      echo 'Use `nix-hash --flat --sri --type sha256 cctools.xcodeproj/project.pbxproj` to regenerate it.'
      exit 1
    fi
  '';

  patches = [
    # Fix compile errors in redo_prebinding.c
    ./0001-Fix-build-issues-with-misc-redo_prebinding.c.patch
    # Use libcd_is_blob_a_linker_signature as defined in the libcodedirectory.h header
    ./0002-Rely-on-libcd_is_blob_a_linker_signature.patch
    # Use the nixpkgs clang’s path as the prefix.
    ./0004-Use-nixpkgs-clang-with-the-assembler-driver.patch
    # Make sure cctools can find ld64 in the store
    ./0005-Find-ld64-in-the-store.patch
    # `ranlib` is a symlink to `libtool`. Make sure its detection works when it is used in cross-compilation.
    ./0006-Support-target-prefixes-in-ranlib-detection.patch
  ];

  postPatch = ''
    substitute ${./meson.build} meson.build \
      --subst-var version
    cp ${./meson.options} meson.options

    # Make sure as’s clang driver uses clang from nixpkgs and finds the drivers in the store.
    substituteInPlace as/driver.c \
      --subst-var-by clang-unwrapped '${lib.getBin buildPackages.clang.cc}' \
      --subst-var-by gas '${placeholder "gas"}'

    # Need to set the path to make sure cctools can find ld64 in the store.
    substituteInPlace libstuff/execute.c \
      --subst-var-by ld64_path '${lib.getBin ld64}/bin/ld'

    # Set the target prefix for `ranlib`
    substituteInPlace misc/libtool.c \
      --subst-var-by targetPrefix '${targetPrefix}'

    # Use libxar from nixpkgs
    for cctool_src in misc/nm.c otool/print_bitcode.c; do
      substituteInPlace $cctool_src \
        --replace-fail 'makestr(prefix, "../lib/libxar.dylib", NULL)' '"${lib.getLib xar}/lib/libxar.dylib"' \
        --replace-fail '/usr/lib/libxar.dylib' '${lib.getLib xar}/lib/libxar.dylib'
    done

    # Use libLTO.dylib from nixpkgs LLVM
    substituteInPlace libstuff/llvm.c \
      --replace-fail 'getenv("LIBLTO_PATH")' '"${lib.getLib llvm}/lib/libLTO.dylib"'

    cp ../xnu-src/EXTERNAL_HEADERS/mach-o/fixup-chains.h include/mach-o/fixup-chains.h
  '';

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    openssl
  ];

  buildInputs = [
    ld64
    llvm
  ];

  mesonBuildType = "release";

  mesonFlags = [
    (lib.mesonOption "b_ndebug" "if-release")
  ]
  ++ lib.optionals (targetPrefix != "") [ (lib.mesonOption "target_prefix" targetPrefix) ];

  postInstall = ''
    ln -s ${targetPrefix}libtool "$out/bin/${targetPrefix}ranlib"
    ln -s nm-classic.1 "''${!outputMan}/share/man/man1/nm.1"
    ln -s otool-classic.1 "''${!outputMan}/share/man/man1/otool.1"
    ln -s size-classic.1 "''${!outputMan}/share/man/man1/size.1"

    # Move GNU as to its own output to prevent it from being used accidentally.
    moveToOutput bin/gas "$gas"
    moveToOutput libexec "$gas"
    for arch in arm i386 x86_64; do
      mv "$gas/libexec/as/$arch/as-$arch" "$gas/libexec/as/$arch/as"
    done

    # Move libtool to its own output to allow packages to add it without pulling in all of cctools
    moveToOutput bin/${targetPrefix}libtool "$libtool"
    ln -s "$libtool/bin/${targetPrefix}libtool" "$out/bin/${targetPrefix}libtool"
  '';

  __structuredAttrs = true;

  passthru = {
    inherit targetPrefix;
    updateScript = gitUpdater { rev-prefix = "cctools-"; };
  };

  meta = {
    description = "Classic linker for Darwin";
    homepage = "https://opensource.apple.com/releases/";
    license = with lib.licenses; [
      apple-psl20
      gpl2 # GNU as
    ];
    teams = [ lib.teams.darwin ];
    platforms = lib.platforms.darwin;
  };
})
