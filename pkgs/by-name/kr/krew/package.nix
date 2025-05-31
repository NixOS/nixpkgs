{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  gitMinimal,
}:

buildGoModule rec {
  pname = "krew";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "krew";
    rev = "v${version}";
    sha256 = "sha256-3GoC2HEp9XJe853/JYvX9kAAcFf7XxglVEeU9oQ/5Ms=";
  };

  vendorHash = "sha256-r4Dywm0+YxWWD59oaKodkldE2uq8hlt9MwOMYDaj6Gc=";

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
