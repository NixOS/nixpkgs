{
  lib,
  stdenv,
  testers,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  container-structure-test,
}:
buildGoModule rec {
  version = "1.20.0";
  pname = "container-structure-test";
  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = "container-structure-test";
    rev = "v${version}";
    sha256 = "sha256-7/RTWpj/W+W4mhQL2HX/6KuMbDFsjh9GGRCGZZ9sNHQ=";
  };
  vendorHash = "sha256-pBq76HJ+nluOMOs9nqBKp1mr1LuX2NERXo48g8ezE9k=";

  subPackages = [ "cmd/container-structure-test" ];
  ldflags = [
    "-X github.com/${src.owner}/${src.repo}/pkg/version.version=${version}"
    "-X github.com/${src.owner}/${src.repo}/pkg/version.buildDate=1970-01-01T00:00:00Z"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      $out/bin/container-structure-test completion $shell > executor.$shell
      installShellCompletion executor.$shell
    done
  '';

  passthru.tests.version = testers.testVersion {
    package = container-structure-test;
    version = version;
    command = "${lib.getExe container-structure-test} version";
  };

  meta = {
    homepage = "https://github.com/GoogleContainerTools/container-structure-test";
    description = "Framework to validate the structure of a container image";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rubenhoenle ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    mainProgram = "container-structure-test";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
