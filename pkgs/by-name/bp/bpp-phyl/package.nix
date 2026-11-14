{
  stdenv,
  fetchFromGitHub,
  cmake,
  bpp-core,
  bpp-seq,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bpp-phyl";

  inherit (bpp-core) version postPatch;

  src = fetchFromGitHub {
    owner = "BioPP";
    repo = "bpp-phyl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QKwbG5Sbjlk1XfJcpCt3Vk7YmNaLCmaAHSBNz42eX6Q=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    bpp-core
    bpp-seq
  ];

  postFixup = ''
    substituteInPlace $out/lib/cmake/bpp-phyl/bpp-phyl-targets.cmake  \
      --replace 'set(_IMPORT_PREFIX' '#set(_IMPORT_PREFIX'
  '';

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = bpp-core.meta // {
    homepage = "https://github.com/BioPP/bpp-phyl";
    changelog = "https://github.com/BioPP/bpp-phyl/blob/master/ChangeLog";
  };
})
