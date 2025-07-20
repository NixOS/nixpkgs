{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
}:

let
  pnpm = pnpm_9;
in
buildGoModule (finalAttrs: {
  pname = "nginx-ui";
  version = "2.1.13";

  src = fetchFromGitHub {
    owner = "0xJacky";
    repo = "nginx-ui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9diwqyu1OQ5x/5UqyvdLWGZdComiezSEmL66OsvM+Yk=";
  };

  postPatch = ''
    substituteInPlace go.mod \
      --replace-fail 'go 1.24.5' 'go 1.24.0' \
      --replace-fail 'github.com/uozi-tech/cosy v1.24.5' 'github.com/uozi-tech/cosy v1.24.2'
  '';

  vendorHash = "sha256-3th8tORVh2UbJD8aAF6Nx2KKQfyWr05y+JMXhxJVVJk=";

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/0xJacky/Nginx-UI/settings.buildTime=0'"
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-KOoz5lOwVSpIicFBq0SWrXW8yO3xRsIx/byv5M0yN/M=";
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
