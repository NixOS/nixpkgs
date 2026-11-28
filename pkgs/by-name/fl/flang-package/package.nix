{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  coreutils,
  gawk,
  gnugrep,
  gnused,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flang-package";
  version = "0.7.30";

  # C bootstrap of the compiler (which is written in flang) with its runtime,
  # standard library, man page and tutor lessons.
  src = fetchurl {
    url = "https://github.com/digitable-lol/flang/releases/download/v${finalAttrs.version}/flang-${finalAttrs.version}-c.tar.gz";
    hash = "sha256-0gBj4CVw2q5IecL50julKsUIp7LeW4Y51msC9cgLxv8=";
  };

  # The archive has no top-level directory.
  sourceRoot = ".";

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  # Upstream builds its macOS release without -flto.
  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    CFLAGS = "-std=c99 -Wall -Wextra -Werror -pedantic -O2";
  };

  # The default target also builds libcompiler_flang.a for the REPL, which
  # cannot be indexed with -flto; upstream ships only the binary on Linux too.
  buildFlags = [ "flang" ];

  # The independent proof checker; `flang check --proof` runs it from
  # ../libexec/flang/checker next to the binary.
  postBuild = ''
    $CC -std=c99 -O2 -o checker checker.c
  '';

  nativeBuildInputs = [ makeWrapper ];

  # Same layout as upstream's release tarballs: the binary looks up
  # ../share/flang (standard library, emit runtimes) next to itself.
  installPhase = ''
    runHook preInstall

    install -Dm0755 flang $out/bin/flang
    install -Dm0755 checker $out/libexec/flang/checker
    install -Dm0644 flang.1 $out/share/man/man1/flang.1
    mkdir -p $out/share/flang $out/share/flang-tutor
    cp -R runtime/. $out/share/flang/
    cp -R tutor/. $out/share/flang-tutor/

    install -Dm0755 flangtutor $out/bin/flangtutor
    wrapProgram $out/bin/flangtutor \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gawk
          gnugrep
          gnused
        ]
      }

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  installCheckPhase = ''
    runHook preInstallCheck

    probe=$(mktemp -d)
    cd "$probe"

    printf 'модуль «Проба»\n\nтотальная функция «Два»\n  возвращает число\n  2\n' > probe.flang
    $out/bin/flang check probe.flang

    printf 'модуль «Кривая»\n\nтотальная функция «Два»\n  возвращает число\n  "два"\n' > broken.flang
    if $out/bin/flang check broken.flang; then
      echo "flang check accepted a broken module" >&2
      exit 1
    fi

    cat > lists.flang <<'FLANG'
    модуль «Проба списков»
      использует «Lists»

    тотальная функция «Три»
      возвращает число
      пример «Три элемента»
        ожидается 3
      «Длина» от [7, 8, 9]
    FLANG
    $out/bin/flang check lists.flang

    # Must fail without share/flang next to the binary.
    mkdir bare
    cp $out/bin/flang bare/flang
    if bare/flang check lists.flang; then
      echo "the standard library was found without share/flang" >&2
      exit 1
    fi

    proved=$($out/bin/flang check probe.flang --proof 2>&1 || true)
    if grep -q 'сверщика нет' <<< "$proved"; then
      echo "check --proof did not find the checker" >&2
      exit 1
    fi

    $out/bin/flang emit probe.flang --target c --out emitted
    test -n "$(ls -A emitted)"

    lessons=$($out/bin/flangtutor --список)
    grep -q '^урок 1 ' <<< "$lessons"

    cd - > /dev/null
    runHook postInstallCheck
  '';

  meta = {
    description = "Verifiable programming language that prints programs into ten other languages";
    longDescription = ''
      flang checks types, termination and the examples of every function and
      prints the program into C, C++, Go, Rust, Java, JavaScript, TypeScript,
      Elixir, Python and C#. Its binary is called `flang`, like LLVM Flang's,
      so the two should not be installed into the same profile.
    '';
    homepage = "https://github.com/digitable-lol/flang";
    changelog = "https://github.com/digitable-lol/flang/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ the-homeless-god ];
    mainProgram = "flang";
  };
})
