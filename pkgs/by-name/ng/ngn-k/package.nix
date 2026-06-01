{
  lib,
  stdenv,
  fetchFromCodeberg,
  runtimeShell,
}:

stdenv.mkDerivation {
  pname = "ngn-k";
  version = "0-unstable-2025-11-17";

  src = fetchFromCodeberg {
    owner = "ngn";
    repo = "k";
    rev = "717063f24921d5aff405a39cf7643efedb5bb365";
    hash = "sha256-rUMi+VetQc139PjbFJXlSkmYEuK5wtM6LpQ/f1tcB1s=";
  };

  patches = [
    ./repl-license-path.patch
    ./repl-argv-1.patch
  ];

  postPatch = ''
    # don't use hardcoded /bin/sh
    for f in repl.k m.c;do
      substituteInPlace "$f" --replace-fail "/bin/sh" "${runtimeShell}"
    done
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
    install -Dm755 repl.k "$out/bin/k-repl"
    install -Dm755 libk.so "$lib/lib/libk.so"
    install -Dm644 k.h "$dev/include/k.h"
    install -Dm644 LICENSE -t "$out/share/ngn-k"
    substituteInPlace "$out/bin/k-repl" --replace-fail "#!k" "#!$out/bin/k"
    runHook postInstall
  '';

  meta = {
    description = "Simple fast vector programming language";
    homepage = "https://codeberg.org/ngn/k";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.sternenseemann ];
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
}
