{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "gofer";
  version = "2.30b";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://web.cecs.pdx.edu/~mpj/goferarc/gofer230b.tar.gz";
    hash = "sha256-f7l+Qez5Up2C4eB+WrKMDXXuiROgCftoU2eTDtl9z9E=";
  };

  sourceRoot = "src";

  patches = [ ./modern-platforms.patch ];

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace cmachine.c \
      --replace-fail /usr/local/lib/Gofer/gofc.h ${placeholder "out"}/lib/gofer/gofc.h
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-int -Wno-implicit-function-declaration -Wno-error=format-security";

  installPhase = ''
    runHook preInstall

    install -Dm755 gofer gofc -t "$out/libexec/gofer"
    install -Dm644 runtime.o gofc.h prelude.h -t "$out/lib/gofer"
    install -Dm644 ../*.prelude -t "$out/lib/gofer"

    makeWrapper "$out/libexec/gofer/gofer" "$out/bin/gofer" \
      --set-default GOFER "$out/lib/gofer/standard.prelude"

    makeWrapper "$out/libexec/gofer/gofc" "$out/bin/gofc" \
      --set-default GOFER "$out/lib/gofer/standard.prelude"

    install -Dm755 ../scripts/goferc "$out/bin/goferc"
    substituteInPlace "$out/bin/goferc" \
      --replace-fail /home/staff/ian/gofer/lib/standard.prelude \
        ${placeholder "out"}/lib/gofer/standard.prelude \
      --replace-fail /usr/local/lib/Gofer/gofc \
        ${placeholder "out"}/libexec/gofer/gofc \
      --replace-fail gcc ${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc \
      --replace-fail /usr/local/lib/Gofer/runtime.o \
        ${placeholder "out"}/lib/gofer/runtime.o \
      --replace-fail strip ':'

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    testDir=$(mktemp -d)
    cd "$testDir"
    printf '1 + 2\n:quit\n' | "$out/bin/gofer" | grep -F '? 3'
    printf 'main = print (1 + 2)\n' > test.gs
    "$out/bin/gofc" test.gs
    test -s test.c
    "$out/bin/goferc" test.gs
    test "$(./test)" = "3"

    runHook postInstallCheck
  '';

  meta = {
    description = "Compiler and interpreter for the Gofer functional programming language";
    homepage = "https://web.cecs.pdx.edu/~mpj/goferarc/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ siraben ];
    mainProgram = "gofer";
    platforms = lib.platforms.unix;
  };
}
