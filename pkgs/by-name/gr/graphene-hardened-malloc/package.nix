{
  fetchFromGitHub,
  lib,
  makeWrapper,
  python3,
  runCommand,
  stdenv,
  stress-ng,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "graphene-hardened-malloc";
  version = "2025092700";

  src = fetchFromGitHub {
    owner = "GrapheneOS";
    repo = "hardened_malloc";
    rev = finalAttrs.version;
    hash = "sha256-t7PnBwpGh53+ZqTbnm8lYaNBtUgLev9kbvFlbfSCBrU=";
  };

  nativeCheckInputs = [ python3 ];
  # these tests cover use as a build-time-linked library
  checkTarget = "test";
  doCheck = true;

  buildPhase = ''
    runHook preBuild

    for VARIANT in default light; do make $makeFlags ''${enableParallelBuilding:+-j$NIX_BUILD_CORES} VARIANT=$VARIANT; done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/include include/*
    install -Dm444 -t $out/lib out/libhardened_malloc.so out-light/libhardened_malloc-light.so

    mkdir -p $out/bin
    substitute preload.sh $out/bin/preload-hardened-malloc --replace "\$dir" $out/lib
    chmod 0555 $out/bin/preload-hardened-malloc

    runHook postInstall
  '';

  separateDebugInfo = true;

  passthru = {
    updateScript = ./update.sh;
    ld-preload-tests = stdenv.mkDerivation {
      name = "${finalAttrs.pname}-ld-preload-tests";
      inherit (finalAttrs) src;

      nativeBuildInputs = [ makeWrapper ];

      # reuse the projects tests to cover use with LD_PRELOAD. we have
      # to convince the test programs to build as though they're naive
      # standalone executables. this includes disabling tests for
      # malloc_object_size, which doesn't make sense to use via LD_PRELOAD.
      buildPhase = ''
        pushd test
        make LDLIBS= LDFLAGS=-Wl,--unresolved-symbols=ignore-all CXXFLAGS=-lstdc++
        substituteInPlace test_smc.py \
          --replace 'test_malloc_object_size' 'dont_test_malloc_object_size' \
          --replace 'test_invalid_malloc_object_size' 'dont_test_invalid_malloc_object_size'
        popd # test
      '';

      installPhase = ''
        mkdir -p $out/test
        cp -r test $out/test

        mkdir -p $out/bin
        makeWrapper ${python3.interpreter} $out/bin/run-tests \
          --add-flags "-I -m unittest discover --start-directory $out/test"
      '';
    };
    tests = {
      ld-preload = runCommand "ld-preload-test-run" { } ''
        ${finalAttrs.finalPackage}/bin/preload-hardened-malloc ${finalAttrs.passthru.ld-preload-tests}/bin/run-tests
        touch $out
      '';
      # to compensate for the lack of tests of correct normal malloc operation
      stress = runCommand "stress-test-run" { } ''
        ${finalAttrs.finalPackage}/bin/preload-hardened-malloc ${stress-ng}/bin/stress-ng \
          --no-rand-seed \
          --malloc 8 \
          --malloc-ops 1000000 \
          --verify
        touch $out
      '';
    };
  };

  meta = with lib; {
    homepage = "https://github.com/GrapheneOS/hardened_malloc";
    description = "Hardened allocator designed for modern systems";
    mainProgram = "preload-hardened-malloc";
    longDescription = ''
      This is a security-focused general purpose memory allocator providing the malloc API
      along with various extensions. It provides substantial hardening against heap
      corruption vulnerabilities yet aims to provide decent overall performance.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
