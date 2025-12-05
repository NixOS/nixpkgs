{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
}:

let
  pnpm = pnpm_10;
in
buildGoModule (finalAttrs: {
  pname = "nginx-ui";
  version = "2.1.17";

  src = fetchFromGitHub {
    owner = "0xJacky";
    repo = "nginx-ui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jFxklALQqrwDchjTYRTbuexJnQH/cAAMJCEzERKGtZs=";
  };

  vendorHash = "sha256-ThRV7Z6CM22iYE1uAjVoiDnlCI1+oqyA4t4gyGQEzjk=";

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/0xJacky/Nginx-UI/settings.buildTime=0'"
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-ozJw9MOJSnNRSKqHBIBsuY9GmbbJm4DGeWOrax3UkmU=";
    sourceRoot = "${finalAttrs.src.name}/app";
  };

  pnpmRoot = "app";

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  overrideModAttrs = _finalModAttrs: _prevModAttrs: {
    inherit (finalAttrs) pnpmDeps pnpmRoot;
  };

  preBuild = ''
    pushd app
    pnpm build
    popd
  '';

  doCheck = false;

  meta = {
    description = "Yet another WebUI for Nginx";
    homepage = "https://github.com/0xJacky/nginx-ui";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ huizengek ];
    mainProgram = "Nginx-UI";
  };
})
