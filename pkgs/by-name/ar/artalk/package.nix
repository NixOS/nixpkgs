{
  lib,
  buildGoModule,
  fetchFromGitHub,
  artalk,
  testers,
  fetchurl,
}:
buildGoModule rec {
  pname = "artalk";
  version = "2.8.6";

  src = fetchFromGitHub {
    owner = "ArtalkJS";
    repo = "artalk";
    rev = "v${version}";
    hash = "sha256-ya/by1PaWdYS/Fsbu6wDKuUcPy55/2F5hJEqko4K57o=";
  };
  web = fetchurl {
    url = "https://github.com/${src.owner}/${src.repo}/releases/download/v${version}/artalk_ui.tar.gz";
    hash = "sha256-3Rg5mCFigLkZ+X8Fxe6A16THd9j6hcTYMEAKU1SrLMw=";
  };

  CGO_ENABLED = 1;

  vendorHash = "sha256-R4/keVGCpCZfLrb2OrK9vdK+N+VKFLAvFXEOA1feqKo=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ArtalkJS/Artalk/internal/config.Version=${version}"
    "-X github.com/ArtalkJS/Artalk/internal/config.CommitHash=${version}"
  ];
  preBuild = ''
    tar -xzf ${web}
    cp -r ./artalk_ui/* ./public
  '';

  passthru.tests = {
    version = testers.testVersion { package = artalk; };
  };

  meta = with lib; {
    description = "A self-hosted comment system";
    homepage = "https://github.com/ArtalkJS/Artalk";
    license = licenses.mit;
    maintainers = with maintainers; [ moraxyc ];
    mainProgram = "Artalk";
  };
}
