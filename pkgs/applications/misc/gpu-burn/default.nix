{ lib, stdenv, fetchFromGitHub, addOpenGLRunpath, cudatoolkit }:

stdenv.mkDerivation rec {
  pname = "gpu-burn";
  version = "unstable-2021-04-29";

  src = fetchFromGitHub {
    owner = "wilicc";
    repo = "gpu-burn";
    rev = "1e9a84f4bec3b0835c00daace45d79ed6c488edb";
    sha256 = "sha256-x+kta81Z08PsBgbf+fzRTXhNXUPBd5w8bST/T5nNiQA=";
  };

  postPatch = ''
    substituteInPlace gpu_burn-drv.cpp \
      --replace "const char *kernelFile = \"compare.ptx\";" \
                "const char *kernelFile = \"$out/share/compare.ptx\";"
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
    maintainers = with maintainers; [ elohmeier ];
    license = licenses.bsd2;
  };
}
