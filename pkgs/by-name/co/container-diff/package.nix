{ stdenv
, lib
, fetchFromGitHub
, buildGoModule
, installShellFiles
, testers
, container-diff
}:

buildGoModule rec {
  pname = "container-diff";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = "container-diff";
    rev = "v${version}";
    hash = "sha256-oihyH4anPDV3vMna7ZKg+5cn9QQVgrUw4qUi2qcyv0w=";
  };

  vendorHash = "sha256-aHF1y8/aoXQ73TwSPymj4yngfeyMB48u6/2Kz4JV/qk=";

  ldflags = [
    "-s" "-w"
    "-X github.com/GoogleContainerTools/container-diff/pkg/version.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false; # uses network

  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    for shell in bash fish zsh; do
      $out/bin/container-diff completion $shell > container-diff.$shell
      installShellCompletion container-diff.$shell
    done
  '';

  passthru.tests.version = testers.testVersion {
    package = container-diff;
    version = "v${version}";
    command = "${container-diff}/bin/container-diff version";
  };

  meta = {
    description = "A tool to diff your Docker containers.";
    homepage = "https://github.com/GoogleContainerTools/container-diff";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ layus ]; # feel free to take ownership ;)
  };
}
