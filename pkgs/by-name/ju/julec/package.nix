{
  lib,
  clangStdenv,
  callPackage,
  fetchFromGitHub,
}:

let
  irFile =
    if clangStdenv.hostPlatform.system == "x86_64-linux" then
      "linux-amd64.cpp"
    else if clangStdenv.hostPlatform.system == "aarch64-linux" then
      "linux-arm64.cpp"
    else if clangStdenv.hostPlatform.system == "i686-linux" then
      "linux-i386.cpp"
    else if clangStdenv.hostPlatform.system == "x86_64-darwin" then
      "darwin-amd64.cpp"
    else if clangStdenv.hostPlatform.system == "aarch64-darwin" then
      "darwin-arm64.cpp"
    else
      throw "Unsupported platform: ${clangStdenv.hostPlatform.system}";
in
clangStdenv.mkDerivation (finalAttrs: {
  pname = "julec";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "julelang";
    repo = "jule";
    tag = "jule${finalAttrs.version}";
    name = "jule-${finalAttrs.version}";
    hash = "sha256-7py8QrNMX8LwpI7LCp5XgRFUzgltFP1rTbuzqw/1D8o=";
  };

  irSrc = fetchFromGitHub {
    owner = "julelang";
    repo = "julec-ir";
    # revision determined by the upstream commit hash in julec-ir/README.md
    rev = "81ddbed06a715428a90d3645f7242fa4e522ea16";
    name = "jule-ir-${finalAttrs.version}";
    hash = "sha256-Az9RDrwRY2kuMgL/Lf/x6YctfySr96/imWZeOa+J/rM=";
  };

  dontConfigure = true;

  unpackPhase = ''
    runHook preUnpack

    cp -R ${finalAttrs.src}/* .
    cp "${finalAttrs.irSrc}/src/${irFile}" ./ir.cpp

    chmod +w -R .

    find ./*/* -type f -name '*.md' -exec rm -f {} +

    runHook postUnpack
  '';

  buildPhase = ''
    runHook preBuild

    echo "Building ${finalAttrs.meta.mainProgram}-bootstrap v${finalAttrs.version} for ${clangStdenv.hostPlatform.system}..."
    mkdir -p bin
    ${clangStdenv.cc.targetPrefix}c++ ir.cpp \
      --std=c++17 \
      -Wno-everything \
      -fwrapv \
      -ffloat-store \
      -fno-fast-math \
      -fno-rounding-math \
      -ffp-contract=fast \
      -fexcess-precision=standard \
      -DNDEBUG \
      -fomit-frame-pointer \
      -fno-strict-aliasing \
      -o "bin/${finalAttrs.meta.mainProgram}-bootstrap"

    echo "Building ${finalAttrs.meta.mainProgram} v${finalAttrs.version} for ${clangStdenv.hostPlatform.system}..."
    bin/${finalAttrs.meta.mainProgram}-bootstrap build \
      -p \
      --opt L2 \
      -o "bin/${finalAttrs.meta.mainProgram}" \
      "src/${finalAttrs.meta.mainProgram}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/jule
    mkdir -p $out/bin
    cp -R api $out/lib/jule/api
    cp -R std $out/lib/jule/std
    cp -R bin $out/lib/jule/bin
    ln -s $out/lib/jule/bin/${finalAttrs.meta.mainProgram} $out/bin/${finalAttrs.meta.mainProgram}

    runHook postInstall
  '';

  passthru = {
    # see doc/hooks/julec.section.md
    hook = callPackage ./hook.nix { julec = finalAttrs.finalPackage; };
    tests.hello-jule = callPackage ./test { julec = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Jule Programming Language Compiler";
    longDescription = ''
      Jule is an effective programming language designed to build efficient, fast, reliable and safe software while maintaining simplicity.
      It is a statically typed, compiled language with a syntax influenced by Go, Rust, and C++.
    '';
    homepage = "https://jule.dev";
    changelog = "https://github.com/julelang/manual/releases/tag/jule${finalAttrs.version}";
    license = lib.licenses.bsd3;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "i686-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "julec";
    maintainers = with lib.maintainers; [
      adamperkowski
      sebaguardian
    ];
  };
})
