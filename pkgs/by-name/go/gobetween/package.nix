{
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  lib,
  enableStatic ? stdenv.hostPlatform.isStatic,
}:

buildGoModule (finalAttrs: {
  pname = "gobetween";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "yyyar";
    repo = "gobetween";
    tag = finalAttrs.version;
    hash = "sha256-xmyqDi2q7J909cWMec9z2u0DJVJjzv86vjYkSfw/3o8=";
  };

  vendorHash = "sha256-3jv0dSsJg90J64Ay7USkUOi8cF1Sj+A7v/snJEdJPFU=";

  env = {
    CGO_ENABLED = 0;
  };

  buildPhase = ''
    runHook preBuild

    make -e build${lib.optionalString enableStatic "-static"}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/gobetween $out/bin
    cp -r share $out/share
    cp -r config $out/share

    runHook postInstall
  '';

  meta = {
    description = "Modern & minimalistic load balancer for the Сloud era";
    homepage = "https://gobetween.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomberek ];
    mainProgram = "gobetween";
  };
})
