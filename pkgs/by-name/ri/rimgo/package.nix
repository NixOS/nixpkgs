{
  lib,
  fetchFromCodeberg,
  buildGoModule,
  tailwindcss_4,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "rimgo";
  version = "1.4.1";

  src = fetchFromCodeberg {
    owner = "rimgo";
    repo = "rimgo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0P2+U4wXiFybpGzV7IB1DXZWC+qIdeQtR6mtiYrrih0=";
  };

  vendorHash = "sha256-unqml6T50BTBzYXXGcL4cc+q9qJJ9W2b2flPBPheBpk=";

  nativeBuildInputs = [ tailwindcss_4 ];

  preBuild = ''
    tailwindcss -i static/tailwind.css -o static/app.css -m
  '';

  ldflags = [
    "-s"
    "-w"
    "-X codeberg.org/rimgo/rimgo/pages.VersionInfo=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Alternative frontend for Imgur";
    homepage = "https://codeberg.org/rimgo/rimgo";
    license = lib.licenses.agpl3Only;
    mainProgram = "rimgo";
    maintainers = with lib.maintainers; [ quantenzitrone ];
  };
})
