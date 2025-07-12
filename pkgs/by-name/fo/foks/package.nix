{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pcsclite,
  pkg-config,
  stdenv,
}:
let
  templFoks = buildGoModule rec {
    pname = "templFoks";
    version = "0.3.833";

    src = fetchFromGitHub {
      owner = "a-h";
      repo = "templ";
      rev = "v${version}";
      hash = "sha256-4K1MpsM3OuamXRYOllDsxxgpMRseFGviC4RJzNA7Cu8=";
    };

    vendorHash = "sha256-OPADot7Lkn9IBjFCfbrqs3es3F6QnWNjSOHxONjG4MM=";

    subPackages = [ "cmd/templ" ];

    env.CGO_ENABLED = 0;

    ldflags = [
      "-s"
      "-w"
      "-extldflags -static"
    ];
    meta = {
      description = "Language for writing HTML user interfaces in Go";
      homepage = "https://github.com/a-h/templ";
      license = lib.licenses.mit;
      mainProgram = "templ";
      maintainers = with lib.maintainers; [
        luleyleo
      ];
    };
  };
in
buildGoModule rec {
  pname = "foks";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "foks-proj";
    repo = "go-foks";
    rev = "v${version}";
    hash = "sha256-nSnbWlwo+Xu3nrX68fmTngWeG2SNCVPBUBf1eI8I9n8=";
  };

  vendorHash = "sha256-4/6UEsUqqhIEYnj4ja1JD2lObGdBcL70x4zxxO4vdEY=";

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

  meta = with lib; {
    homepage = "https://foks.pub";
    description = "Federated key management and distribution system";
    mainProgram = "foks";
    license = licenses.mit;
    maintainers = with maintainers; [ poptart ];
  };
}
