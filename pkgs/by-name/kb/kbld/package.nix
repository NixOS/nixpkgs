{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kbld";
  version = "0.49.2";

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "kbld";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BMiT/JNlny2Gla/6sw63nBSqqLvaBJ8Rvr11cj/4vDQ=";
  };

  vendorHash = null;

  subPackages = [ "cmd/kbld" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-X=carvel.dev/kbld/pkg/kbld/version.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Seamlessly incorporates image building and image pushing into your development and deployment workflows";
    homepage = "https://carvel.dev/kbld/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benchand ];
    mainProgram = "kbld";
  };
})
