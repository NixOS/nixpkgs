{
  stdenv,
  fetchFromGitHub,
  cmake,
  bpp-core,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bpp-seq";

  inherit (bpp-core) version postPatch;

  src = fetchFromGitHub {
    owner = "BioPP";
    repo = "bpp-seq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EwvLKbyTo4FkuEcIoBEe2pdgu0xlu/w4UfpzLdFLgNU=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ bpp-core ];

  postFixup = ''
    substituteInPlace $out/lib/cmake/bpp-seq/bpp-seq-targets.cmake  \
      --replace 'set(_IMPORT_PREFIX' '#set(_IMPORT_PREFIX'
  '';
  # prevents cmake from exporting incorrect INTERFACE_INCLUDE_DIRECTORIES
  # of form /nix/store/.../nix/store/.../include,
  # probably due to relative vs absolute path issue

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = bpp-core.meta // {
    homepage = "https://github.com/BioPP/bpp-seq";
    changelog = "https://github.com/BioPP/bpp-seq/blob/master/ChangeLog";
  };
})
