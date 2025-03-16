{
  lib,
  stdenv,
  fetchFromGitHub,
  clang,
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
      abort "Unsupported platform: ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation rec {
  pname = "julec";
  version = "0.1.2";
  irCommit = "03f3ebe18a79bb8dcb5440f0e6297e1d2e032e19";

  src = fetchFromGitHub {
    owner = "julelang";
    repo = "jule";
    rev = "jule${version}";
    name = "jule-${version}";
    sha256 = "FhM25fff0TAhnO1RX0rhqHyox7ksyqYFBKSFby/4i0E=";
  };

  irSrc = fetchFromGitHub {
    owner = "julelang";
    repo = "julec-ir";
    rev = irCommit;
    name = "jule-ir-${version}";
    sha256 = "0omZu/2t09eOqbLAps3KdGy6InrtzeIoM3rLtkmJwqE=";
  };

  dontConfigure = true;
  propagatedBuildInputs = [ clang ];

  unpackPhase = ''
    cp -R ${src}/* .
    cp "${irSrc}/src/${irFile}" ./ir.cpp
    mkdir -p bin

    chmod +w -R .

    find ./*/* -type f -name '*.md' -exec rm -f {} +
  '';

  buildPhase = ''
    echo "Building ${pname} v${version} for ${stdenv.hostPlatform.system}..."
    clang++ ./ir.cpp \
      --std=c++17 \
      -O0 \
      -Wno-everything \
      -o "bin/${pname}"
  '';

  installPhase = ''
    mkdir -p $out/lib/jule
    mkdir -p $out/bin
    cp -R api $out/lib/jule/api
    cp -R std $out/lib/jule/std
    cp -R bin $out/lib/jule/bin
    ln -s $out/lib/jule/bin/${pname} $out/bin/${pname}
  '';

  meta = with lib; {
    description = "The Jule Programming Language Compiler";
    longDescription = ''
      Jule is an effective programming language designed to build efficient, fast, reliable and safe software while maintaining simplicity.
      It is a statically typed, compiled language with a syntax influenced by Go, Rust, and C++.
    '';
    homepage = "https://jule.dev";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      adamperkowski
      sebaguardian
    ];
  };
}
