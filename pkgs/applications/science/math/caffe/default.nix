{ stdenv
, openblas
, boost
, cudaSupport ? true
, cudnnSupport ? false
, cudnn ? null
, cudatoolkit7
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
  # Use git revision because latest "release" is really old
  name = "caffe-git-2015-07-02";

  src = fetchFromGitHub {
    owner = "BVLC";
    repo = "caffe";
    rev = "77d66dfc907dd875d69bb9fc12dd950b531e464f";
    sha256 = "0vd4qrc49dhsawj298xpkd5mvi35sh56kdswx3yp8ya4fjajwakx";
  };

  preConfigure = "mv Makefile.config.example Makefile.config";

  makeFlags = "BLAS=open " +
              (if !cudaSupport then "CPU_ONLY=1 " else "CUDA_DIR=${cudatoolkit7} ") +
              (if cudnnSupport then "USE_CUDNN=1 " else "");

  # too many issues with tests to run them for now
  doCheck = false;
  checkPhase = "make runtest ${makeFlags}";

  buildInputs = [ openblas boost google-gflags glog hdf5 leveldb lmdb opencv
                  protobuf snappy ]
                ++ optional cudaSupport cudatoolkit7
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
