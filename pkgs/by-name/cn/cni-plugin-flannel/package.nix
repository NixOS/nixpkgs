{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cni-plugin-flannel";
  version = "1.9.1-flannel3";

  src = fetchFromGitHub {
    owner = "flannel-io";
    repo = "cni-plugin";
    rev = "v${version}";
    sha256 = "sha256-MPR8Nu+EZ/P+xSeEig6EmQVG0qaGt6g6/Fe3jIz1fqU=";
  };

  vendorHash = "sha256-JTy9MsTyWvnqtRH0hzezYwgB23mfG7KtI9OmynpcESM=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.Commit=${version}"
    "-X main.Program=flannel"
  ];

  postInstall = ''
    mv $out/bin/cni-plugin $out/bin/flannel
  '';

  doCheck = false;
  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/flannel 2>&1 | fgrep -q $version
    runHook postInstallCheck
  '';

  meta = {
    description = "Network fabric for containers designed to work in conjunction with flannel";
    mainProgram = "flannel";
    homepage = "https://github.com/flannel-io/cni-plugin/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ abbe ];
  };
}
