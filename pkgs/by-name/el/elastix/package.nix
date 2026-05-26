{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  itk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elastix";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "SuperElastix";
    repo = "elastix";
    tag = finalAttrs.version;
    hash = "sha256-edUMj8sjku8EVYaktteIDS+ouaN3kg+CXQCeSWKlLDI=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ itk ];

  doCheck = !stdenv.hostPlatform.isDarwin; # usual dynamic linker issues

  meta = {
    homepage = "https://elastix.dev";
    description = "Image registration toolkit based on ITK";
    changelog = "https://github.com/SuperElastix/elastix/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ bcdarwin ];
    mainProgram = "elastix";
    platforms = lib.platforms.x86_64; # libitkpng linker issues with ITK 5.1
    license = lib.licenses.asl20;
  };
})
