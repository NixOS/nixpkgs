{
  lib,
  stdenv,
  fetchgit,
  gcc,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "cakelisp";
  # using unstable as it's the only version that builds against gcc-13
  version = "0.3.0-unstable-2024-04-25";

  src = fetchgit {
    url = "https://macoy.me/code/macoy/cakelisp";
    rev = "eb4427f555c3def9d65612672ccfe59e11b14059";
    hash = "sha256-wFyqAbHrBMFKqMYlBjS6flYHPn3Rxtaiqb1rRmlZrB4=";
  };

  buildInputs = [ gcc ];

  postPatch =
    ''
      substituteInPlace runtime/HotReloading.cake \
          --replace '"/usr/bin/g++"' '"${gcc}/bin/g++"'
      substituteInPlace src/ModuleManager.cpp \
          --replace '"/usr/bin/g++"' '"${gcc}/bin/g++"'
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace Build.sh --replace '--export-dynamic' '-export_dynamic'
      substituteInPlace runtime/HotReloading.cake --replace '--export-dynamic' '-export_dynamic'
      substituteInPlace Bootstrap.cake --replace '--export-dynamic' '-export_dynamic'
    '';

  buildPhase = ''
    runHook preBuild
    ./Build.sh
    runHook postBuild
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=format";

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/cakelisp -t $out/bin
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://macoy.me/code/macoy/cakelisp";
  };

  meta = with lib; {
    description = "Performance-oriented Lisp-like language";
    mainProgram = "cakelisp";
    homepage = "https://macoy.me/code/macoy/cakelisp";
    license = licenses.gpl3Plus;
    platforms = platforms.darwin ++ platforms.linux;
    maintainers = [ maintainers.sbond75 ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
  };
}
