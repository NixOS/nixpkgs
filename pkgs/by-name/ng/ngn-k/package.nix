{
  lib,
  stdenv,
  fetchFromCodeberg,
  runtimeShell,
  ncurses,
  runCommand,
  expect,
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

  postPatch = ''
    # don't use hardcoded /bin/sh
    for f in repl.k m.c;do
      substituteInPlace "$f" --replace-fail "/bin/sh" "${runtimeShell}"
    done
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=discarded-qualifiers";

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
    install -Dm755 repl.k "$out/bin/k-repl"
    install -Dm755 libk.so "$lib/lib/libk.so"
    install -Dm644 k.h "$dev/include/k.h"
    install -Dm644 LICENSE -t "$out/share/ngn-k"
    substituteInPlace "$out/bin/k-repl" \
      --replace-fail "#!k" "#!$out/bin/k" \
      --replace-fail '"LICENSE"' '"../share/ngn-k/LICENSE"' \
      --replace-fail '"repl.k"~basename' '"k-repl"~basename' \
      --replace-fail '"/usr/bin/env";"tput"' '"${lib.getExe' ncurses "tput"}"'
    runHook postInstall
  '';

  passthru.tests.repl =
    runCommand "ngn-k-repl-test"
      {
        nativeBuildInputs = [ expect ];
        meta.timeout = 60;
      }
      ''
        expect <<'EOF'
        set timeout 60
        spawn ${lib.getExe' finalAttrs.finalPackage "k-repl"}
        expect_before timeout { exit 1 } eof { exit 1 }
        expect "for more info"
        send {\a}
        send "\r"
        expect "GNU AFFERO GENERAL PUBLIC LICENSE"
        send "2!!7!4\r"
        expect "0 1 0 1"
        send {\\}
        send "\r"
        expect_before
        expect eof
        exit [lindex [wait] 3]
        EOF
        touch "$out"
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
    mainProgram = "k";
    maintainers = [ lib.maintainers.sternenseemann ];
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})
