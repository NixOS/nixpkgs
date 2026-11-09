{
  lib,
  fetchzip,
  buildPackages,
  stdenv,
  makeBinaryWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mirth";
  version = "0-unstable-2026-11-08";
  gitRev = "0e81709995b272b514ec7bb9b69b2a0320f54b89";
  __structuredAttrs = true;

  src = fetchzip {
    urls = [
      "https://codeberg.org/typeswitch/mirth/archive/${finalAttrs.gitRev}.tar.gz"
      "https://github.com/mirth-lang/mirth/archive/${finalAttrs.gitRev}.zip"
      "https://git.sr.ht/~typeswitch/mirth/archive/${finalAttrs.gitRev}.tar.gz"
    ];
    hash = "sha256-FSldpgTCtn7S2bDA6oOCaL+hkutqdLvU0WXy4soSE2o=";
  };

  postPatch =
    # Bug report: https://codeberg.org/typeswitch/mirth/issues/1
    lib.optionalString (with stdenv.buildPlatform; isAarch64 && isLinux) ''
      substituteInPlace bin/mirth0.c \
        --replace-fail "WRAP_I63(24LL);" "WRAP_I63(16LL);"
      substituteInPlace lib/std/world.mth \
        --replace-fail "Linux -> 24u," "Linux -> running-arch Arch.ARM64 = if(16u, 24u),"
    ''
    # Replace hard-coded GCC with stdenv’s C compiler.
    # NOTE: newer GCC requires optimization level ≥1 to use fortity. -O1 is
    # fast enough as a default for the compiler stages.
    + ''
      substituteInPlace Makefile \
        --replace-fail "-O0" "-O1" \
        --replace-fail "CC=gcc \$(C99FLAGS)" "CC=${buildPackages.stdenv.cc.targetPrefix}cc \$(C99FLAGS)"
    ''
    # Override the final binary, mirth3, with the target’s C compiler & -O2
    # optimization for distribution.
    + ''
      echo "bin/mirth3: CC := ${stdenv.cc.targetPrefix}cc \$(C99FLAGS) -O2" >>Makefile
    '';

  outputs = [
    "out"
    "lib"
    "doc"
    "examples"
  ];

  strictDeps = true;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildFlags = [
    "bin/mirth2"
    "bin/mirth3"
  ];

  # st_mode substitution intentionally diverges from the pre-generated mirth0.c
  doCheck = with stdenv.buildPlatform; !(isAarch64 && isLinux);

  installPhase = ''
    runHook preInstall

    install -d "$lib/lib/mirth" "$doc/share/doc/mirth/tutorial" \
      "$examples/share/mirth/examples"

    cp -Tr lib "$lib/lib/mirth"
    cp -Tr examples "$examples/share/mirth/examples"
    cp -Tr tutorial "$doc/share/doc/mirth/tutorial"

    bin/mirth2 src/main.mth --docs "$doc/share/doc/mirth" -c
    install -Dm644 LICENSE README.md -t "$doc/share/doc/mirth"

    # stages 0–2 aren’t needed anymore; the unwrapped compiler is kept for
    # users wrapping Mirth with their own stdlib & other packages
    install -Dm755 bin/mirth3 "$out/bin/mirth3"

    runHook postInstall
  '';

  # `mirthc` is the wrapped user entry point: the raw compiler + stdlib search
  # path, so it works from any cwd
  postFixup = ''
    makeBinaryWrapper "$out/bin/mirth3" "$out/bin/mirthc" \
      --add-flags "-P $lib/lib/mirth"
  '';

  meta = {
    description = "Concatenative functional programming language with strong static linear types";
    longDescription = ''
      Mirth is inspired by Forth, Joy, Haskell, Lisp, and monoidal category theory.
      Mirth compiles to C99.
    '';
    homepage = "https://git.sr.ht/~typeswitch/mirth";
    license = lib.licenses.bsd0;
    mainProgram = "mirthc";
    # https://git.sr.ht/~typeswitch/mirth/tree/main/item/src/mirth.h#L4-22
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "aarch64-windows"
      "i686-linux"
      "i686-windows"
      "x86_64-linux"
      "x86_64-windows"
    ];
    maintainers = with lib.maintainers; [ toastal ];
  };
})
