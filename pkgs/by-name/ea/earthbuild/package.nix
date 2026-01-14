{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  testers,
}:

buildGoModule (finalAttrs: rec {
  pname = "earthbuild";
  version = "0.8.17-rc-0";

  src = fetchFromGitHub {
    owner = "EarthBuild";
    repo = "earthbuild";
    rev = "v${version}";
    hash = "sha256-SQqZb1PO4Xtjtz62kmkHVuOxsBlwma3XR17sgjfTBws=";
  };

  vendorHash = "sha256-J0OIwNoVZd3Yj2GI4ztthvnMNdN0OltuTtt34EyIzyg=";
  subPackages = [
    "cmd/earthly"
    "cmd/debugger"
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${version}"
    "-X main.DefaultBuildkitdImage=docker.io/earthbuild/buildkitd:v${version}"
    "-X main.GitSha=v${version}"
    "-X main.DefaultInstallationName=earthly"
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
    ln -s $out/bin/earthly-debugger $out/bin/earthbuild-debugger
    ln -s $out/bin/earthly $out/bin/earthbuild
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "v${version}";
    };
  };

  meta = {
    description = "Build automation for the container era";
    mainProgram = "earthly";
    homepage = "https://earthly.dev/";
    changelog = "https://github.com/EarthBuild/earthbuild/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      zoedsoupe
      konradmalik
    ];
  };
})
