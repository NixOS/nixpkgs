{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  linux-pam,

  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "bifroest";
  version = "0.7.7";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "engity-com";
    repo = "bifroest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UstOg/BRPrcYN3uFrKJKj7AHpP56NOEGIV1bIMccNoM=";
  };

  vendorHash = "sha256-9yPWISGdsPnd4KNrZrbJ9ytQGpjncMjkUia30eBEw44=";

  ldflags = [
    "-s"
    "-X main.os=${stdenv.hostPlatform.go.GOOS}"
    "-X main.arch=${stdenv.hostPlatform.go.GOARCH}"
    "-X main.edition=${if stdenv.hostPlatform.isLinux then "extended" else "generic"}"
    "-X main.version=v${finalAttrs.version}"
    "-X main.revision=${finalAttrs.src.rev}"
    "-X main.vendor=NixOS"
    "-X main.buildAt=1970-01-01T00:00:00Z"
  ];

  subPackages = [ "cmd/bifroest" ];

  doInstallCheck = true;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    linux-pam
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SSH server and gateway for standard SSH clients featuring OIDC Device Authorization, Docker/Kubernetes sessions${lib.optionalString (lib.versionAtLeast finalAttrs.version "1.0") ", verifiable audit and recording"}";
    homepage = "https://bifroest.engity.org";
    changelog = "https://github.com/engity-com/bifroest/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20 # Bifroest
      bsd3 # Go templates
      mit # ca-certs parser
      mpl20 # ca-certs
    ];
    maintainers = with lib.maintainers; [ sigmasquadron ];
    platforms = lib.platforms.all;
    mainProgram = "bifroest";
  };
})
