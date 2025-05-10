{
  lib,
  stdenv,
  fetchFromGitHub,
}:

let
  irFile =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      "linux-amd64.cpp"
    else if stdenv.hostPlatform.system == "aarch64-linux" then
      "linux-arm64.cpp"
    else if stdenv.hostPlatform.system == "i686-linux" then
      "linux-i386.cpp"
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      "darwin-amd64.cpp"
    else if stdenv.hostPlatform.system == "aarch64-darwin" then
      "darwin-arm64.cpp"
    else
      throw "Unsupported platform: ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "julec";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "julelang";
    repo = "jule";
    tag = "jule${finalAttrs.version}";
    name = "jule-${finalAttrs.version}";
    hash = "sha256-hFWoGeTmfXIPcICWXa5W36QDOk3yB7faORxFaM9shcQ=";
  };

  irSrc = fetchFromGitHub {
    owner = "julelang";
    repo = "julec-ir";
    # revision determined by the upstream commit hash in julec-ir/README.md
    rev = "a274782922e4275c4a036d63acffd3369dbc382f";
    name = "jule-ir-${finalAttrs.version}";
    hash = "sha256-TXMSXTGTzZntPUhT6QTmn3nD2k855ZoAW9aQWyhrE8s=";
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

    echo "Building ${finalAttrs.meta.mainProgram} v${finalAttrs.version} for ${stdenv.hostPlatform.system}..."
    mkdir -p bin
    ${stdenv.cc.targetPrefix}c++ ir.cpp \
      --std=c++17 \
      -Wno-everything \
      -O3 \
      -flto \
      -DNDEBUG \
      -fomit-frame-pointer \
      -o "bin/${finalAttrs.meta.mainProgram}"

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
