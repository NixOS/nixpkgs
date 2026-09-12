{
  lib,
  stdenv,
  fetchFromCodeberg,
  makeWrapper,
  runtimeShell,
  runCommand,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ngn-k";
  version = "0-unstable-2025-11-17";

  src = fetchFromCodeberg {
    owner = "ngn";
    repo = "k";
    rev = "717063f24921d5aff405a39cf7643efedb5bb365";
    hash = "sha256-rUMi+VetQc139PjbFJXlSkmYEuK5wtM6LpQ/f1tcB1s=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    # don't use hardcoded /bin/sh
    for f in repl.k m.c;do
      substituteInPlace "$f" --replace-fail "/bin/sh" "${runtimeShell}"
    done
    substituteInPlace repl.k --replace-fail '"LICENSE"' '"../share/ngn-k/LICENSE"'
  '';

  makeFlags = [ "-e" ];
  buildFlags = [
    "k"
    "libk.so"
  ];
  checkTarget = "t";
  doCheck = true;

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  # TODO(@sternenseemann): package bulgarian translation
  installPhase = ''
    runHook preInstall
    install -Dm755 k "$out/bin/k"
    install -Dm755 repl.k "$out/bin/repl.k"
    install -Dm755 libk.so "$lib/lib/libk.so"
    install -Dm644 k.h "$dev/include/k.h"
    install -Dm644 LICENSE -t "$out/share/ngn-k"
    substituteInPlace "$out/bin/repl.k" --replace-fail "#!k" "#!$out/bin/k"
    makeWrapper "$out/bin/repl.k" "$out/bin/k-repl"
    runHook postInstall
  '';

  passthru.tests.repl = runCommand "ngn-k-repl-test" { nativeBuildInputs = [ util-linux ]; } ''
    printf '\\a\n 2!!7!4\n' \
      | script -qec ${lib.getExe' finalAttrs.finalPackage "k-repl"} /dev/null \
        > "$out" 2>&1 || true
    grep -q 'GNU AFFERO GENERAL PUBLIC LICENSE' "$out"
    grep -q '0 1 0 1' "$out"
  '';

  passthru.tests.eval = runCommand "ngn-k-eval-test" { } ''
    echo '2!!7!4' > prog.k
    ${lib.getExe' finalAttrs.finalPackage "k"} prog.k > "$out"
    [ "$(cat "$out")" = "0 1 0 1" ]
  '';

  meta = {
    description = "Simple fast vector programming language";
    homepage = "https://codeberg.org/ngn/k";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.sternenseemann ];
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})
