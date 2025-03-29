{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nixosTests,
  nix-update-script,
}:

buildGoModule rec {
  pname = "miniflux";
  version = "2.2.6";

  src = fetchFromGitHub {
    owner = "miniflux";
    repo = "v2";
    tag = version;
    hash = "sha256-N0WAdfxToVF93ICGpDstQig3aGz2lAzJz1nf4tSvxAY=";
  };

  vendorHash = "sha256-AG3NNqwpaTctvgOEZ2SarsMK4SRgzWxf+j9N4wwKKB4=";

  nativeBuildInputs = [ installShellFiles ];

  checkFlags = [ "-skip=TestClient" ]; # skip client tests as they require network access

  ldflags = [
    "-s"
    "-w"
    "-X miniflux.app/v2/internal/version.Version=${version}"
  ];

  postInstall = ''
    mv $out/bin/miniflux.app $out/bin/miniflux
    installManPage miniflux.1
  '';

  passthru = {
    tests = nixosTests.miniflux;
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Minimalist and opinionated feed reader";
    homepage = "https://miniflux.app/";
    license = licenses.asl20;
    maintainers = with maintainers; [
      rvolosatovs
      benpye
      emilylange
      adamcstephens
    ];
    mainProgram = "miniflux";
  };
}
