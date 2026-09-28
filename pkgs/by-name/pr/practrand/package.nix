{
  lib,
  stdenv,
  fetchurl,
  unzip,
  nix-update-script,
  programPrefix ? "PractRand-",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "practrand";
  version = "0.96";
  __structuredAttrs = true;
  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://sourceforge/pracrand/PractRand_${finalAttrs.version}.zip";
    hash = "sha256-5Mr3/amLLFl7vaO1dnU89aD2BHqrg3yCvjcKt5imcuE=";
  };

  nativeBuildInputs = [ unzip ];

  env.NIX_CFLAGS_COMPILE = "-O3";

  buildPhase = ''
    runHook preBuild

    $CXX -Iinclude -pthread -c src/*.cpp src/RNGs/*.cpp src/RNGs/other/*.cpp
    $AR rcs libPractRand.a ./*.o

    for tool in RNG_test RNG_benchmark RNG_output; do
      $CXX -Iinclude -Itools -pthread -o "$tool" "tools/$tool.cpp" libPractRand.a
    done

    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ./RNG_test --self_test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    for tool in RNG_test RNG_benchmark RNG_output; do
      install -Dm755 "$tool" "$out/bin/${programPrefix}$tool"
    done
    install -Dm644 libPractRand.a -t "$dev/lib"
    mkdir -p "$dev/include" "$out/share/doc/practrand"
    cp -r include/. "$dev/include/"
    cp -r doc/. "$out/share/doc/practrand/"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Suite of statistical tests and pseudo-random number generators";
    homepage = "https://sourceforge.net/projects/pracrand/";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ edoars ];
    platforms = lib.intersectLists lib.platforms.unix lib.platforms.x86;
  };
})
