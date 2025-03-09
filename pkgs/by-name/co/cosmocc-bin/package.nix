{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cosmocc-bin";
  version = "3.8.0";

  src = fetchurl {
    # Recommended in README, also can be downloaded in GitHub release
    url = "https://cosmo.zip/pub/cosmocc/cosmocc-${finalAttrs.version}.zip";
    hash = "sha256-gTxrL5UGLS4KhFMHp5UFQky5jLA46AEzNPiiLjuSpHQ=";
  };

  nativeBuildInputs = [ unzip ];

  unpackCmd = ''
    mkdir ${finalAttrs.src.name}
    unzip $src -d ./${finalAttrs.src.name}
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';

  # Prevent referencing to anything from normal stdenv
  dontFixup = true;

  outputHash = "sha256-0OUuHpwE3LrWz0Oridyb4cUvHQUBY64dW1Mjpf/2GZI=";
  outputHashMode = "recursive";

  meta = {
    description = "Cosmopolitan toolchain, upstream artifact for bootstrapping purpose";
    longDescription = ''
      This toolchain can be used to compile executables that run
      on Linux / MacOS / Windows / FreeBSD / OpenBSD / NetBSD for
      both the x86_64 and AARCH64 architectures. In addition to
      letting you create portable binaries, your toolchain is itself
      comprised of portable binaries, enabling you to have a consistent
      development environment that lets you reach a broader audience
      from the platform(s) of your choosing.

      This toolchain bundles GCC 14.1.0, Clang 19, Cosmopolitan Libc,
      LLVM LIBCXX, LLVM compiler-rt, and LLVM OpenMP. Additional
      libraries were provided by Musl Libc, and the venerable BSDs OSes.
      This lets you benefit from the awesome modern GCC compiler with
      the strongest GPL barrier possible. The preprocessor advertises
      cross compilers as both __COSMOCC__ and __COSMOPOLITAN__ whereas
      cosmocc additionally defines __FATCOSMOCC__.
    '';
    homepage = "https://github.com/jart/cosmopolitan/blob/master/tool/cosmocc/README.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = with lib.platforms; lib.lists.intersectLists (aarch64 ++ x86_64) (unix ++ windows);
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
