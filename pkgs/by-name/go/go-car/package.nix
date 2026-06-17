{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule (finalAttrs: {
  pname = "go-car";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "ipld";
    repo = "go-car";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ams0SK9Dz9McW3GLwyndCrRluvaaJiychbZX1pSW3Nw=";
  };

  modRoot = "cmd";
  subPackages = [ "car" ];

  vendorHash = "sha256-ZbMhX4H1rHdkdK6YIGDmSzro9q9PmkYvx9UhBaJ/i4M=";

  buildInputs = [ libpcap ];

  ldflags = [ "-s" ];

  meta = {
    description = "Content addressable archive utility";
    homepage = "https://github.com/ipld/go-car";
    changelog = "https://github.com/ipld/go-car/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ malik ];
    mainProgram = "car";
  };
})
