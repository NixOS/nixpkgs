{
  lib,
  fetchzip,
  buildPackages,
  stdenv,
  makeBinaryWrapper,
  runCommandCC,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mirth";
  version = "0-unstable-2026-11-15";
  gitRev = "f7b4b1a9e19c66e01ce16f92b3d64787e7ea26b6";
  __structuredAttrs = true;

  src = fetchzip {
    urls = [
      "https://codeberg.org/typeswitch/mirth/archive/${finalAttrs.gitRev}.tar.gz"
      "https://github.com/mirth-lang/mirth/archive/${finalAttrs.gitRev}.zip"
      "https://git.sr.ht/~typeswitch/mirth/archive/${finalAttrs.gitRev}.tar.gz"
    ];
    hash = "sha256-S++vkfwOQsAdxnBRm6bGa9u+bJPxrvbPOtkkrqhfvbg=";
  };

  postPatch = ''
    # Replace hard-coded GCC with stdenv’s C compiler.
    # NOTE: newer GCC requires optimization level ≥1 to use fortity. -O1 is
    # fast enough as a default for the compiler stages.
    #
    # glibc marks write(2) with warn_unused_result, which the generated
    # bootstrap’s TRACE macro ignores.
    # noted: https://codeberg.org/typeswitch/mirth/issues/1
    substituteInPlace Makefile \
      --replace-fail "-O0" "-O1" \
      --replace-fail "-Werror" "-Werror -Wno-error=unused-result" \
      --replace-fail "CC=gcc \$(C99FLAGS)" "CC=${buildPackages.stdenv.cc.targetPrefix}cc \$(C99FLAGS)"

    # Override the final binary, mirth3, with the target’s C compiler & -O2
    # optimization for distribution.
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

  doCheck = true;

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
    install -Dm755 bin/mirth3 "$out/bin/.mirthc-unwrapped"

    runHook postInstall
  '';

  # `mirthc` is the wrapped user entry point: the raw compiler + stdlib search
  # path, so it works from any cwd
  postFixup = ''
    makeBinaryWrapper "$out/bin/.mirthc-unwrapped" "$out/bin/mirthc" \
      --add-flags "-P $lib/lib/mirth"
  '';

  passthru.tests = {
    hello-world =
      runCommandCC "${finalAttrs.pname}-hello-world"
        {
          src = finalAttrs.finalPackage.examples;
          buildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          mirthc -o hello.c "$src/share/mirth/examples/hello.mth"
          cc -o hello hello.c
          if [ ! -x ./hello ]; then
            echo "Did not make ./hello executable" >&2
            exit 1
          fi
          if [ "$(./hello)" != "Hello, world!" ]; then
            echo "Did not print “Hello, world!”" >&2
            exit 1
          fi
          touch "$out"
        '';
  };

  meta = {
    description = "Concatenative functional programming language with strong static linear types";
    longDescription = ''
      Mirth is inspired by Forth, Joy, Haskell, Lisp, and monoidal category theory.
      Mirth compiles to C99.
    '';
    homepage = "https://codeberg.org/typeswitch/mirth";
    license = lib.licenses.bsd0;
    mainProgram = "mirthc";
    # https://codeberg.org/typeswitch/mirth/src/branch/main/src/mirth.h#L4-L22
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
