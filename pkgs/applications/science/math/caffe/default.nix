{ stdenv
, openblas
, boost
, cudaSupport ? true
, cudnnSupport ? false
, cudnn ? null
, cudatoolkit
, fetchFromGitHub
, google-gflags
, glog
, hdf5
, leveldb
, lmdb
, opencv
, protobuf
, snappy
}:


let optional = stdenv.lib.optional;
in stdenv.mkDerivation rec {
  name = "caffe-${version}";
  version = "1.0-rc5";

  src = fetchFromGitHub {
    owner = "BVLC";
    repo = "caffe";
    rev = "rc5";
    sha256 = "0lfmmc0n6xvkpygvxclzrvd0zigb4yfc5612anv2ahlxpfi9031c";
  };

  preConfigure = "mv Makefile.config.example Makefile.config";

  makeFlags = [ "BLAS=open"
                (if !cudaSupport then "CPU_ONLY=1" else "CUDA_DIR=${cudatoolkit}") ]
              ++ optional cudnnSupport "USE_CUDNN=1";

  # too many issues with tests to run them for now
  doCheck = false;
  checkTarget = "runtest";

  enableParallelBuilding = true;

  buildInputs = [ openblas boost google-gflags glog hdf5 leveldb lmdb opencv
                  protobuf snappy ]
                ++ optional cudaSupport cudatoolkit
                ++ optional cudnnSupport cudnn;

  installPhase = ''
    mkdir -p $out/{bin,share,lib}
    for bin in $(find build/tools -executable -type f -name '*.bin');
    do
      cp $bin $out/bin/$(basename $bin .bin)
    done

    cp -r build/examples $out/share
    cp -r build/lib $out
  '';

  meta = with stdenv.lib; {
    description = "Deep learning framework";
    longDescription = ''
      Caffe is a deep learning framework made with expression, speed, and
      modularity in mind. It is developed by the Berkeley Vision and Learning
      Center (BVLC) and by community contributors.
    '';
    homepage = http://caffe.berkeleyvision.org/;
    maintainers = with maintainers; [ jb55 ];
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
