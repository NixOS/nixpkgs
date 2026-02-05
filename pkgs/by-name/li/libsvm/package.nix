{
  lib,
  stdenv,
  fetchFromGitHub,
  fixDarwinDylibNames,
  llvmPackages,
  withOpenMP ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsvm";
  version = "333";

  src = fetchFromGitHub {
    owner = "cjlin1";
    repo = "libsvm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eM7O/skOcxkKV4utlC7G9FvMO+d2yZm5D0BoIUhAPXo=";
  };

  patches = lib.optionals withOpenMP [ ./openmp.patch ];

  buildInputs = lib.optionals (stdenv.cc.isClang && withOpenMP) [ llvmPackages.openmp ];

  buildFlags = [
    "lib"
    "all"
  ];

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];

  installPhase =
    let
      libSuff = stdenv.hostPlatform.extensions.sharedLibrary;
      soVersion = "3";
      libName =
        if stdenv.hostPlatform.isDarwin then
          "libsvm.${soVersion}${libSuff}"
        else
          "libsvm${libSuff}.${soVersion}";
    in
    ''
      runHook preInstall

      install -D libsvm.so.${soVersion} $out/lib/${libName}
      ln -s $out/lib/${libName} $out/lib/libsvm${libSuff}

      install -Dt $bin/bin/ svm-scale svm-train svm-predict

      install -Dm644 -t $dev/include svm.h
      mkdir $dev/include/libsvm
      ln -s $dev/include/svm.h $dev/include/libsvm/svm.h

      runHook postInstall
    '';

  meta = {
    description = "Library for support vector machines";
    homepage = "https://www.csie.ntu.edu.tw/~cjlin/libsvm/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
