{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  testers,
  earthbuild,
}:

buildGoModule (finalAttrs: {
  pname = "earthbuild";
  version = "0.8.17";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Earthbuild";
    repo = "earthbuild";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ATdNA9KjAXsxMiez3AF6TxK7OujNDABY8jB6hXeSNpc=";
  };

  vendorHash = "sha256-49FWzLHEbgwWOXT1uPshdY5risFHInA541Mfhu7v08A=";
  subPackages = [
    "cmd/earthly"
    "cmd/debugger"
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${finalAttrs.src.tag}"
    "-X main.DefaultBuildkitdImage=docker.io/earthbuild/buildkitd:v${finalAttrs.src.tag}"
    "-X main.GitSha=v${finalAttrs.src.tag}"
    "-X main.DefaultInstallationName=earthbuild"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "-extldflags '-static'"
  ];

  tags = [
    "dfrunmount"
    "dfrunnetwork"
    "dfrunsecurity"
    "dfsecrets"
    "dfssh"
  ];

  postInstall = ''
    mv $out/bin/debugger $out/bin/earthly-debugger
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = earthbuild;
      version = "v${finalAttrs.src.tag}";
    };
  };

  meta = {
    description = "Simple, fast, and consistent build system for containerized, reproducible builds. Community-maintained fork of Earthly";
    homepage = "https://www.earthbuild.dev/";
    changelog = "https://github.com/Earthbuild/earthbuild/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      eonpatapon
    ];
  };
})
