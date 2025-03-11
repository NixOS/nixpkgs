{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  gitMinimal,
}:

buildGoModule rec {
  pname = "krew";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "krew";
    rev = "v${version}";
    sha256 = "sha256-SN6F7EmkgjtU4UHYPXWBiuXSSagjQYD6SBYBXRrSVGA=";
  };

  vendorHash = "sha256-3tEesDezIyB6005PZmOcrnEeAIvc5za3FxTmBBbKf7s=";

  subPackages = [ "cmd/krew" ];

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/krew \
      --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
  '';

  meta = with lib; {
    description = "Package manager for kubectl plugins";
    mainProgram = "krew";
    homepage = "https://github.com/kubernetes-sigs/krew";
    maintainers = with maintainers; [ vdemeester ];
    license = lib.licenses.asl20;
  };
}
