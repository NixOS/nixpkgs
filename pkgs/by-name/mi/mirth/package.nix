{
  lib,
  fetchFromSourcehut,
  buildPackages,
  stdenv,
  makeBinaryWrapper,
}:

stdenv.mkDerivation {
  name = "mirth";
  version = "0-unstable-2026-05-28";

  src = fetchFromSourcehut {
    owner = "~typeswitch";
    repo = "mirth";
    rev = "b180112a547cb803e3bf5720a0bb08f8bffa9742";
    hash = "sha256-6nd1DrN3sGobmOh+E/8hYUFW2tBSFLdaEPXrViKDVSc=";
  };

  postPatch =
    # Bug report: https://todo.sr.ht/~typeswitch/mirth/16
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
    "bin"
    "doc"
    "examples"
    "vim"
  ];

  strictDeps = true;
  __structuredAttrs = true;

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
      "$examples/share/mirth/examples" "$vim"

    cp -Tr lib "$lib/lib/mirth"
    cp -Tr examples "$examples/share/mirth/examples"
    cp -Tr tutorial "$doc/share/doc/mirth/tutorial"
    cp -Tr tools/mirth-vim  "$vim"

    bin/mirth2 src/main.mth --docs "$doc/share/doc/mirth" -c
    install -Dm644 LICENSE README.md -t "$doc/share/doc/mirth"

    # stages 0–2 aren’t needed anymore
    install -Dm755 bin/mirth3 "$bin/bin/mirth"

    runHook postInstall
  '';

  # The raw binary @ $bin needs wrapping to get the stdlib @ $lib. By wrapping
  # it here, it will be more flexible towards allowing users to wrap the Mirth
  # binary with their own stdlib & other packages.
  postFixup = ''
    makeBinaryWrapper "$bin/bin/mirth" "$out/bin/mirth" \
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
    mainProgram = "mirth";
    # https://git.sr.ht/~typeswitch/mirth/tree/main/item/src/mirth.h#L4-22
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "aarch64-windows"
      "i686-linux"
      "i686-windows"
      "x86_64-darwin"
      "x86_64-linux"
      "x86_64-windows"
    ];
    maintainers = with lib.maintainers; [ toastal ];
  };
}
