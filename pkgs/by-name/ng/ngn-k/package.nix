{
  lib,
  stdenv,
  stdenvNoLibs,
  fetchFromGitea,
  runtimeShell,
  doCheck ? withLibc && stdenv.hostPlatform == stdenv.buildPlatform,
  withLibc ? true,
}:

let
  # k itself can be compiled with -ffreestanding, but tests require a libc;
  # if we want to build k-libc we need a libc obviously
  useStdenv = if withLibc || doCheck then stdenv else stdenvNoLibs;
in

useStdenv.mkDerivation {
  pname = "ngn-k";
  version = "unstable-2022-11-28";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ngn";
    repo = "k";
    rev = "e5138f182a8ced07dd240e3fe58274130842a85d";
    sha256 = "1pn416znrdndb8iccprzx4zicmsx8c6i9dm3wq5z3jg8nan53p69";
  };

  patches = [
    ./repl-license-path.patch
  ];

  postPatch = ''
    patchShebangs --build a19/a.sh a20/a.sh a21/a.sh dy/a.sh e/a.sh

    # don't use hardcoded /bin/sh
    for f in repl.k repl-bg.k m.c;do
      substituteInPlace "$f" --replace "/bin/sh" "${runtimeShell}"
    done
  '';

  makeFlags = [ "-e" ];
  buildFlags = [
    (if withLibc then "k-libc" else "k")
    "libk.so"
  ];
  checkTarget = "t";
  inherit doCheck;

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
    substituteInPlace "$out/bin/k-repl" --replace "#!k" "#!$out/bin/k"
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
