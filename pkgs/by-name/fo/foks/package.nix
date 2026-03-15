{
  lib,
  buildGoModule,
  fetchFromGitHub,
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
  pname = "foks";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "foks-proj";
    repo = "go-foks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/+Z/afzj5y4CVU3qRymSIUzCabT2jAEBlKKoYgKlPRE=";
  };

  vendorHash = "sha256-nTHsYMQjVaQM+g2MM++/BDVYfzIM4CaMM6eK5GQE6Cc=";

  postPatch = ''
    cd ./server/web/templates
    ${templFoks}/bin/templ generate
    cd -
  '';
  postInstall = ''
    ln -s $out/bin/{foks,git-remote-foks}
  '';

  subPackages = [ "client/foks" ];
  excludedPackages = [ "server" ];

  buildInputs = lib.optionals (stdenv.hostPlatform.isLinux) [ pcsclite ];
  nativeBuildInputs = [
    pkg-config
  ];

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
