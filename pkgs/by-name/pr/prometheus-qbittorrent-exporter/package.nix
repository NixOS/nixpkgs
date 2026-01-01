{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "prometheus-qbittorrent-exporter";
<<<<<<< HEAD
  version = "1.13.0";
=======
  version = "1.12.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "martabal";
    repo = "qbittorrent-exporter";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-ivHTGj2+6c23KW5aT5a8NFzUxV13u0y9UnHttZYTkuA=";
  };
  sourceRoot = "${finalAttrs.src.name}/src";

  vendorHash = "sha256-FHKt2QpvianVVbAJUcaou/+Ok69a8NbkM7ymVgxUi0I=";
=======
    hash = "sha256-9J4nGG52M7SSeXigLBJK/dqXRvSpPqOGRJ8BQx7+1eU=";
  };
  sourceRoot = "${finalAttrs.src.name}/src";

  vendorHash = "sha256-jJmhRnjioeTq9Uol0lYLChPi4O1D9JnGqN7q1XK36yE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-X 'qbit-exp/app.version=v${finalAttrs.version}'"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Prometheus exporter for qBittorrent";
    homepage = "https://github.com/martabal/qbittorrent-exporter";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      typedrat
      undefined-landmark
    ];
    mainProgram = "qbit-exp";
  };
})
