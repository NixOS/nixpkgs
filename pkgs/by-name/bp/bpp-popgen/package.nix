{
  stdenv,
  fetchFromGitHub,
  cmake,
  bpp-core,
  bpp-seq,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bpp-popgen";

  inherit (bpp-core) version postPatch;

  src = fetchFromGitHub {
    owner = "BioPP";
    repo = "bpp-popgen";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cDuOA3siIOX8LZxFS//PFWmbN/2DuQ2BMjG3gTN04C8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    bpp-core
    bpp-seq
  ];

  postFixup = ''
    substituteInPlace $out/lib/cmake/bpp-popgen/bpp-popgen-targets.cmake  \
      --replace 'set(_IMPORT_PREFIX' '#set(_IMPORT_PREFIX'
  '';
  # prevents cmake from exporting incorrect INTERFACE_INCLUDE_DIRECTORIES
  # of form /nix/store/.../nix/store/.../include,
  # probably due to relative vs absolute path issue

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = bpp-core.meta // {
    homepage = "https://github.com/BioPP/bpp-popgen";
    changelog = "https://github.com/BioPP/bpp-popgen/blob/master/ChangeLog";
  };
})
