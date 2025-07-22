{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  sphinx,
  python3Packages,
  ctestCheckHook,
  enableShared ? (!stdenv.hostPlatform.isStatic),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ckdl";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "tjol";
    repo = "ckdl";
    tag = finalAttrs.version;
    hash = "sha256-qEfRZzoUQZ8umdWgx+N4msjPBbuwDtkN1kNDfZicRjY=";
  };

  outputs = [
    "bin"
    "dev"
    "doc"
    "out"
  ];

  postBuild = ''
    pushd ../doc
    make singlehtml
    popd
  '';

  nativeBuildInputs = [
    cmake
    ninja
    sphinx
    python3Packages.furo
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BUILD_SHARED_LIBS" enableShared)
  ];

  nativeCheckInputs = [ ctestCheckHook ];

  doCheck = true;

  postInstall = ''
    # some tools that are important for debugging.
    # idk why they are not copied to bin by cmake, but I’m too tired to figure it out
    for exe in src/utils/ckdl-{tokenize,parse-events,cat}; do
      ${lib.optionalString enableShared "patchelf --set-rpath $out/lib $exe"}
      install -Dm755 $exe -t $bin/bin
    done

    mkdir -p $doc/share/doc
    mv ../doc/_build/singlehtml $doc/share/doc/ckdl
  '';

  meta = {
    description = "C (C11) library that implements reading and writing the KDL Document Language";
    homepage = "https://ckdl.readthedocs.io";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aleksana ];
  };
})
