{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "certigo";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "square";
    repo = "certigo";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-dn2GqEiSzlcqNPoAZhPESRsl3LOUBlaPs59rUjf2c5k=";
  };

  vendorHash = "sha256-hBuR6a0gBhuYICbuiHxJdbDr4hLF4mQvIcMr5FHfOu8=";

  meta = {
    description = "Utility to examine and validate certificates in a variety of formats";
    homepage = "https://github.com/square/certigo";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "certigo";
  };
})
