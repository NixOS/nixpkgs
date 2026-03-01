{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  gitMinimal,
}:

buildGoModule (finalAttrs: {
  pname = "krew";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "krew";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-KG4/vtEfwWVddfFoNbC4xakxOynDY6jyxek4JAXW5gY=";
  };

  vendorHash = "sha256-z0wiYknXcCx4vqROngn58CRe9TBgya4y3v736VBMhQ8=";

  subPackages = [ "cmd/krew" ];

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/krew \
      --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
  '';

  meta = {
    description = "Package manager for kubectl plugins";
    mainProgram = "krew";
    homepage = "https://github.com/kubernetes-sigs/krew";
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.asl20;
  };
})
