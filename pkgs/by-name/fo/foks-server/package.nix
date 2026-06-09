{
  lib,
  buildGoModule,
  fetchFromGitHub,
  foks,
  pcsclite,
  pkg-config,
  stdenv,
  buildPackages,
}:
let
  templFoks = buildPackages.templ.overrideAttrs (old: {
    pname = "templ-foks";
    version = "0.3.833";
    src = old.src.override {
      hash = "sha256-4K1MpsM3OuamXRYOllDsxxgpMRseFGviC4RJzNA7Cu8=";
    };
    vendorHash = "sha256-OPADot7Lkn9IBjFCfbrqs3es3F6QnWNjSOHxONjG4MM=";
  });
in
buildGoModule (finalAttrs: {
  pname = "foks-server";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "foks-proj";
    repo = "go-foks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JY0ec+LNRQf0S8gTeazvQhvQ7LRM3zz1qvopGPaKM1k=";
  };

  vendorHash = "sha256-W0lyLy7k3xin8VSdxNgeh1FpHprOKIDduHIW3Oqk1LY=";

  postPatch = ''
    cd ./server/web/templates
    templ generate
    cd -
  '';
  postInstall = ''
    ln -s $out/bin/{foks-server,git-remote-foks}
  '';

  subPackages = [ "server/foks-server" ];
  excludedPackages = [ "server" ];

  buildInputs = lib.optionals (stdenv.hostPlatform.isLinux) [ pcsclite ];
  nativeBuildInputs = [
    pkg-config
    templFoks
    foks
  ];
  __structuredAttrs = true;

  meta = {
    description = "Federated key management and distribution system";
    homepage = "https://foks.pub";
    downloadPage = "https://github.com/foks-proj/go-foks";
    changelog = "https://github.com/foks-proj/go-foks/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ poptart ];
    mainProgram = "foks";
  };
})
