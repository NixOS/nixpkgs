{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "elfinfo";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "elfinfo";
    rev = finalAttrs.version;
    sha256 = "sha256-HnjHOjanStqmDXnc6Z9w0beCMJFf/ndWbYxoDEaOws4=";
  };

  vendorHash = null;

  meta = {
    description = "Small utility for showing information about ELF files";
    mainProgram = "elfinfo";
    homepage = "https://elfinfo.roboticoverlords.org/";
    changelog = "https://github.com/xyproto/elfinfo/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
