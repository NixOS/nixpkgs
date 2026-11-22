{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "izrss";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "izrss";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WVbuT33EHz/wNyOLguaV8vgtSstEKm35DkGEISldz+s=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-PVrdIpyNF9FwnG1jmBQPdE/CHxGZGUSbNTPeo7uWvvw=";

  meta = {
    description = "RSS feed reader for the terminal written in Go";
    changelog = "https://github.com/isabelroses/izrss/releases/v${finalAttrs.version}";
    homepage = "https://github.com/isabelroses/izrss";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      isabelroses
      luftmensch-luftmensch
    ];
    mainProgram = "izrss";
  };
})
