{
  lib,
  stdenv,
  fetchFromGitea,
  clojure,
  graalvmPackages,
  git,
  cmake,
  ninja,
  zlib,
  cacert,
}:

let
  pname = "flower";
  version = "0.0.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "jyn514";
    repo = "flower";
    rev = "fc051518d4ff298344f869b184574ae6a4a2df79";
    hash = "sha256-etVQnrdGzOfrohZ4rWAk3Pk1PylUFIho30JLwwfOMHo=";
  };

  # Pre-download Clojure dependencies into a Fixed-Output Derivation.
  deps = stdenv.mkDerivation {
    pname = "flower-deps";
    inherit version src;

    nativeBuildInputs = [
      clojure
      git
      cacert
    ];

    buildPhase = ''
      export HOME="$(pwd)"
      export _JAVA_OPTIONS="-Duser.home=$HOME -Xmx2g"
      export GITLIBS="$HOME/.gitlibs"

      set -e

      clojure -P
      clojure -P -T:build
      clojure -P -M:dev:test
    '';

    installPhase = ''
      mkdir -p $out
      [ -d $HOME/.m2 ] && cp -a $HOME/.m2 $out/
      [ -d $HOME/.gitlibs ] && cp -a $HOME/.gitlibs $out/
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-sO2VFyP+SqSIr28YQtLhu2glufaNQEg8pyE7wY4S7YQ=";
  };

in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    clojure
    graalvmPackages.graalvm-ce
    git
    cmake
    cacert
  ];

  buildInputs = [
    zlib
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME="$(pwd)"
    export _JAVA_OPTIONS="-Duser.home=$HOME"
    export GITLIBS="$HOME/.gitlibs"

    # Restore cached Clojure dependencies
    [ -d ${deps}/.m2 ] && cp -R ${deps}/.m2 $HOME/
    [ -d ${deps}/.gitlibs ] && cp -R ${deps}/.gitlibs $HOME/
    chmod -R u+w $HOME/.m2 $HOME/.gitlibs || true

    # Provide a dummy git repository. `native.clj` uses `git describe --always`
    # and expects a tracked `defaults` folder to generate `MANIFEST.txt`.
    git init -b main || git init
    git config user.name "Nix Build"
    git config user.email "nix-build@localhost"
    git add .
    git commit -m "Dummy commit"

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Setting CI=true triggers `--parallelism=4` and `-J-Xmx4g` in `native.clj`,
    # preventing GraalVM from exhausting memory.
    export CI=true

    # Passing `:include-untracked true` ensures `MANIFEST.txt` contains all default files
    # even if git tracking is slightly off due to our dummy repo initialization.
    clojure -T:build native :include-untracked true

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 target/flower $out/bin/flower

    runHook postInstall
  '';

  meta = {
    description = "Static site generator that grows with you";
    homepage = "https://flower.jyn.dev";
    changelog = "https://codeberg.org/jyn514/flower/src/branch/main/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "flower";
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.unix;
  };
}
