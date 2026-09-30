{
  lib,
  applyPatches,
  cmake,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "numkong";
  version = "7.8.3";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  __structuredAttrs = true;
  strictDeps = true;

  # Patched via applyPatches so that usearch and python3Packages.numkong also easily get the fixes
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "ashvardanian";
      repo = "NumKong";
      tag = "v${finalAttrs.version}";
      hash = "sha256-GOs4NsTUBUWuAZX4Hy0+bpCrvq5HfzpgHzRDs60mZ/I=";
    };

    # Upstream wraps the SME headers with `#pragma GCC target("+sme…")`,
    # but the function bodies also use plain SVE intrinsics like `svwhilelt_b16_u64` and `svld1_f32`.
    # Clang treats `target("sme")` as implying streaming-SVE and accepts them; GCC doesn't,
    # and refuses to compile with "requires ISA extension 'sve'".
    postPatch = ''
      for f in \
        include/numkong/attention/sme.h \
        include/numkong/dots/sme.h \
        include/numkong/maxsim/sme.h \
        include/numkong/spatials/sme.h ; do
        substituteInPlace "$f" \
          --replace-fail '#pragma GCC target("+sme")' \
                         '#pragma GCC target("+sme+sve2+bf16+fp16")'
      done
      for f in \
        include/numkong/dots/smebi32.h \
        include/numkong/sets/smebi32.h ; do
        substituteInPlace "$f" \
          --replace-fail '#pragma GCC target("+sme2")' \
                         '#pragma GCC target("+sme2+sve2+bf16+fp16")'
      done
      for f in \
        include/numkong/curved/smef64.h \
        include/numkong/dots/smef64.h \
        include/numkong/spatials/smef64.h ; do
        substituteInPlace "$f" \
          --replace-fail '#pragma GCC target("+sme+sme-f64f64")' \
                         '#pragma GCC target("+sme+sme-f64f64+sve2+bf16+fp16")'
      done
    '';
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Portable mixed-precision math, linear-algebra, & retrieval library with 2000+ SIMD kernels for x86, Arm, RISC-V, LoongArch, Power, & WebAssembly";
    homepage = "https://github.com/ashvardanian/NumKong/";
    changelog = "https://github.com/ashvardanian/NumKong/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
