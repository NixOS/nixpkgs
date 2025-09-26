{
  lib,
  clangStdenv,
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
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "julelang";
    repo = "jule";
    tag = "jule${finalAttrs.version}";
    name = "jule-${finalAttrs.version}";
    hash = "sha256-y4v8FdQkB5Si3SYkchFG9fAU4ZhabAMcPkDcLEWW+6k=";
  };

  irSrc = fetchFromGitHub {
    owner = "julelang";
    repo = "julec-ir";
    # revision determined by the upstream commit hash in julec-ir/README.md
    rev = "aebbd12c0f89f6a04f856f3e23d5ea39741c3e0f";
    name = "jule-ir-${finalAttrs.version}";
    hash = "sha256-7eDOYMmCEfW+0zZpESY1+ql3hWZZ/Q75lKT0nBQPktE=";
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
    bin/${finalAttrs.meta.mainProgram}-bootstrap --opt L2 -p -o "bin/${finalAttrs.meta.mainProgram}" "src/${finalAttrs.meta.mainProgram}"

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
