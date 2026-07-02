{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  alsa-lib,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osmid";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "llloret";
    repo = "osmid";
    rev = "v${finalAttrs.version}";
    sha256 = "1s1wsrp6g6wb0y61xzxvaj59mwycrgy52r4h456086zkz10ls6hw";
  };

  postPatch = ''
    # replace deprecated cmake version that are no longer supported by CMake > 4
    # https://github.com/NixOS/nixpkgs/issues/445447

    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 3.0)" "cmake_minimum_required (VERSION 3.10)"
    substituteInPlace external_libs/oscpack_1_1_0/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.6)" "cmake_minimum_required (VERSION 3.10)"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    alsa-lib
    libx11
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp {m2o,o2m} $out/bin/
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/llloret/osmid";
    description = "Lightweight, portable, easy to use tool to convert MIDI to OSC and OSC to MIDI";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ c0deaddict ];
    platforms = lib.platforms.linux;
  };
})
