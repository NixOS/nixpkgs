{ lib, stdenv, fetchFromGitHub, addOpenGLRunpath, cudatoolkit }:

stdenv.mkDerivation {
  pname = "gpu-burn";
  version = "unstable-2023-11-10";

  src = fetchFromGitHub {
    owner = "wilicc";
    repo = "gpu-burn";
    rev = "b99aedce3e020d2ca419832ee27b7f29dfa6373e";
    sha256 = "sha256-cLO0GXvujZ+g64j+OY31n43MsVER3ljo8Qrt+EzSKjc=";
  };

  postPatch = ''
    substituteInPlace gpu_burn-drv.cpp \
      --replace "#define COMPARE_KERNEL \"compare.ptx\"" \
                "#define COMPARE_KERNEL \"$out/share/compare.ptx\""
  '';

  buildInputs = [ cudatoolkit ];

  nativeBuildInputs = [ addOpenGLRunpath ];

  makeFlags = [ "CUDAPATH=${cudatoolkit}" ];

  LDFLAGS = "-L${cudatoolkit}/lib/stubs";

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp gpu_burn $out/bin/
    cp compare.ptx $out/share/
  '';

  postFixup = ''
    addOpenGLRunpath $out/bin/gpu_burn
  '';

  meta = with lib; {
    homepage = "http://wili.cc/blog/gpu-burn.html";
    description = "Multi-GPU CUDA stress test";
    platforms = platforms.linux;
    license = licenses.bsd2;
    mainProgram = "gpu_burn";
  };
}
