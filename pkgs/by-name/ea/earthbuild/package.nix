{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "earthbuild";
  version = "0.8.17";

  src = fetchFromGitHub {
    owner = "EarthBuild";
    repo = "earthbuild";
    rev = "v${finalAttrs.version}";
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
    "-X main.Version=v${finalAttrs.version}"
    "-X main.DefaultBuildkitdImage=docker.io/earthbuild/buildkitd:v${finalAttrs.version}"
    "-X main.GitSha=v${finalAttrs.version}"
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
    ln -s $out/bin/earthly-debugger $out/bin/earth-debugger
    ln -s $out/bin/earthly $out/bin/earth
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "Build automation for the container era";
    mainProgram = "earth";
    homepage = "https://earthbuild.dev/";
    changelog = "https://github.com/EarthBuild/earthbuild/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      zoedsoupe
      konradmalik
    ];
  };
})
