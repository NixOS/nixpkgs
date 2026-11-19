{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
}:

buildGoModule (finalAttrs: {
  pname = "git-flow-next";
  version = "2.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gittower";
    repo = "git-flow-next";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hLvUHSXGDLYMQylh74qTKuOQetQR8fNaoh7sjceNyEg=";
  };

  vendorHash = "sha256-AsyF7Z/XRpkBNBWULxf3rLfx0/2jCSBAbDFhESFMuPA=";
  subPackages = [ "." ];

  postInstall = ''
    mv $out/bin/git-flow-next $out/bin/git-flow
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ gitMinimal ];
  installCheckPhase = ''
    runHook preInstallCheck
    PATH="$out/bin:$PATH" git flow version | grep -F '${finalAttrs.version}'
    runHook postInstallCheck
  '';

  meta = {
    description = "Go reimplementation of git-flow compatible with git-flow and git-flow-avh";
    homepage = "https://github.com/gittower/git-flow-next";
    license = lib.licenses.bsd2;
    mainProgram = "git-flow";
    maintainers = [ lib.maintainers.RumBugen ];
  };
})
