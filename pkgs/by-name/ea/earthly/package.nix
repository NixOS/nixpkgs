{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  testers,
  earthly,
}:

buildGoModule (finalAttrs: {
  pname = "earthly";
  version = "0.8.16";

  src = fetchFromGitHub {
    owner = "earthly";
    repo = "earthly";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2+Ya5i6V2QDzHsYR+Ro14u0VWR3wrQJHZRXBatGC8BA=";
  };

  vendorHash = "sha256-kEgg7zrT69X4yrsGtLyvnrGQ7+sXaEzdqd4Fz7rpFyg=";
  subPackages = [
    "cmd/earthly"
    "cmd/debugger"
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${finalAttrs.version}"
    "-X main.DefaultBuildkitdImage=docker.io/earthly/buildkitd:v${finalAttrs.version}"
    "-X main.GitSha=v${finalAttrs.version}"
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
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = earthly;
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "Build automation for the container era";
    homepage = "https://earthly.dev/";
    changelog = "https://github.com/earthly/earthly/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      zoedsoupe
      konradmalik
    ];
  };
})
