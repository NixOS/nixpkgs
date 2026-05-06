{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  openssl,
  libllvm,
  libxml2,
  replaceVars,
  llvmPackages,
  buildllvmsparse ? false,
  buildc2xml ? false,
}:
let
  version = "1.75";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "smatch";
  inherit version;

  src = fetchFromGitHub {
    owner = "error27";
    repo = "smatch";
    tag = finalAttrs.version;
    hash = "sha256-sku4mOOniG1EN5H1pkTWhL1j5660VZhZesoQeR6ZvhI=";
  };

  patches = [
    (
      let
        clang-major = lib.versions.major (lib.getVersion llvmPackages.clang-unwrapped);
        clang-lib = lib.getLib llvmPackages.clang-unwrapped;
      in
      replaceVars ./fix_include_path.patch {
        clang = "${clang-lib}/lib/clang/${clang-major}/include";
        libc = "${lib.getDev stdenv.cc.libc}/include";
      }
    )
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    sqlite
    openssl
  ]
  ++ lib.optionals buildllvmsparse [ libllvm ]
  ++ lib.optionals buildc2xml [ libxml2.dev ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  meta = {
    description = "Semantic analysis tool for C";
    homepage = "https://sparse.docs.kernel.org/";
    maintainers = with lib.maintainers; [ momeemt ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
