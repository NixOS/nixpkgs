{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  gitMinimal,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "krew";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "krew";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rhl4qVHwl876OSDrcLSS07x3H/x/zmFLPHdRw+fcYsw=";
    leaveDotGit = true;
    postFetch = ''
      git -C "$out" rev-parse --short HEAD > "$out/.git_head"
      rm -rf "$out/.git"
    '';
  };

  vendorHash = "sha256-z0wiYknXcCx4vqROngn58CRe9TBgya4y3v736VBMhQ8=";

  subPackages = [ "cmd/krew" ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-X"
    "sigs.k8s.io/krew/internal/version.gitTag=v${finalAttrs.version}"
  ];

  preBuild = ''
    ldflags+=" -X=sigs.k8s.io/krew/internal/version.gitCommit=$(<.git_head)"
  '';

  postFixup = ''
    wrapProgram $out/bin/krew \
      --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Package manager for kubectl plugins";
    mainProgram = "krew";
    homepage = "https://github.com/kubernetes-sigs/krew";
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.asl20;
  };
})
