{
  lib,
  stdenv,
  buildGoModule,
  buildPackages,
  fetchFromGitHub,
  versionCheckHook,

  pcsclite,
  pkg-config,
  foks, # self

  server ? false,
}:
let
  client = !server;
  pname = if server then "foks-server" else "foks";
  subPackages = if server then [ "server/foks-server" ] else [ "client/foks" ];
in
buildGoModule (finalAttrs: {
  inherit pname;
  version = "0.1.7";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "foks-proj";
    repo = "go-foks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UZ4BZ2/S44hnG+uLHtWR/qqQtr6tbbQbQOgIrN4ciT0=";
  };

  vendorHash = "sha256-+ysHa5KNhoxtoXPgOWC9ZDJKYqF+84s7oyxRib2S6a8=";

  postPatch = ''
    cd ./server/web/templates
    templ generate
    cd -
  '';

  inherit subPackages;
  excludedPackages = [ "server" ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pcsclite ];
  nativeBuildInputs = [
    pkg-config
    finalAttrs.passthru.templ
  ];

  postInstall = lib.optionalString client ''
    ln -s $out/bin/{foks,git-remote-foks}
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    templ = buildPackages.templ.overrideAttrs (old: {
      pname = "templ-foks";
      version = "0.3.833";
      src = old.src.override {
        hash = "sha256-4K1MpsM3OuamXRYOllDsxxgpMRseFGviC4RJzNA7Cu8=";
      };
      vendorHash = "sha256-OPADot7Lkn9IBjFCfbrqs3es3F6QnWNjSOHxONjG4MM=";
    });
    server = foks.override { server = true; };
  };

  meta = {
    description = "Federated key management and distribution system";
    homepage = "https://foks.pub";
    downloadPage = "https://github.com/foks-proj/go-foks";
    changelog = "https://github.com/foks-proj/go-foks/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ poptart ];
    mainProgram = pname;
  };
})
