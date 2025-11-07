{
  lib,
  stdenv,
  fetchFromGitea,
  runtimeShell,
}:

stdenv.mkDerivation {
  pname = "ngn-k";
  version = "0-unstable-2025-01-04";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ngn";
    repo = "k";
    rev = "feb51a61443dac03213c4e97edd8df679a4a3aaa";
    sha256 = "14v2bwbgaxi1rsq5xabp5dmv0bl0vga3lhzwdxyvsyl9q7qybf55";
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
    platforms = [
      "x86_64-linux"
      "x86_64-freebsd"
    ];
  };
}
