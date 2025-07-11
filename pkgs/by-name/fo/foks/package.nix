{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pcsclite,
  pkg-config,
  stdenv,
  templ,
}:
let
  templFoks = templ.overrideAttrs (old: {
    pname = "templ-foks";
    version = "0.3.833";
    src = old.src.override {
      hash = "sha256-4K1MpsM3OuamXRYOllDsxxgpMRseFGviC4RJzNA7Cu8=";
    };
    vendorHash = "sha256-OPADot7Lkn9IBjFCfbrqs3es3F6QnWNjSOHxONjG4MM=";
  });
in
buildGoModule rec {
  pname = "foks";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "foks-proj";
    repo = "go-foks";
    tag = "v${version}";
    hash = "sha256-N4sWxYnHeqvG/qcqoqakUbxjtoh8CNPegYPYdrgP+z4=";
  };

  vendorHash = "sha256-8/SVOWMoCfeiuH2As2cC/HLRs1WQIQ4/Ko1olXDq6bo=";

  postPatch = ''
    cd ./server/web/templates
    ${templFoks}/bin/templ generate
    cd -
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
    changelog = "https://github.com/foks-proj/go-foks/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ poptart ];
    mainProgram = "foks";
  };
}
