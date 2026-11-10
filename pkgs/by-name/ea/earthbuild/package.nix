{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "earthbuild";
  version = "0.8.18";

  src = fetchFromGitHub {
    owner = "EarthBuild";
    repo = "earthbuild";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ydi649sjAnObI4PrbdwVQifWVHyTmJsj2qqJ54rXllQ=";
  };

  vendorHash = "sha256-w5JnfSJ5yNtrc6IM2kCWXAJGbszpvA49rQQJ2+ynlg0=";

  __structuredAttrs = true;
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
