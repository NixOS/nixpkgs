{
  lib,
  buildPackages,
  callPackage,
  clang-tools,
  fetchFromGitLab,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libffi-wasm";
  version = "20260905";

  src = fetchFromGitLab {
    domain = "gitlab.haskell.org";
    owner = "haskell-wasm";
    repo = "libffi-wasm";
    tag = finalAttrs.version;
    hash = "sha256-VBsLHSWoq32qwuQOR1dkPIMm3gJiNwThpjEMR4CGOf0=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    (buildPackages.haskellPackages.ghcWithPackages (p: [
      p.async
      p.language-c
    ]))
    clang-tools
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wall"
    "-Wextra"
    "-mcpu=mvp"
    "-Oz"
    "-DNDEBUG"
    "-Icbits"
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    runghc -isrc app/Main.hs

    for f in cbits/*.c; do
      $CC -c "$f" -o "''${f%.c}.o"
    done
    $AR rcs libffi.a cbits/*.o

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 -t "$dev/include" cbits/*.h
    install -Dm444 -t "$out/lib" libffi.a

    mkdir -p "$dev/lib/pkgconfig"
    cat > "$dev/lib/pkgconfig/libffi.pc" <<EOF
    prefix=$out
    libdir=\''${prefix}/lib
    includedir=$dev/include

    Name: libffi-wasm
    Description: ${finalAttrs.meta.description}
    Version: ${finalAttrs.version}
    Libs: -L\''${libdir} -lffi
    Cflags: -I\''${includedir}
    EOF

    runHook postInstall
  '';

  passthru = {
    tests = {
      pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
      upstream = callPackage ./test.nix { libffi-wasm = finalAttrs.finalPackage; };
    };
    updateScript = buildPackages.nix-update-script { };
  };

  meta = {
    description = "Limited implementation of libffi for wasm32";
    longDescription = ''
      A limited libffi implementation for wasm32. Supports up to 4 arguments
      and 16 closures per function type. Structures and variadic functions are
      unsupported. The closure API differs from upstream libffi.
    '';
    homepage = "https://gitlab.haskell.org/haskell-wasm/libffi-wasm";
    changelog = "https://gitlab.haskell.org/haskell-wasm/libffi-wasm/-/tags/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ilkecan ];
    platforms = [ "wasm32-wasip1" ];
    pkgConfigModules = [ "libffi" ];
  };
})
