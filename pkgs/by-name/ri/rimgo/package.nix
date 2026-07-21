{
  lib,
  fetchFromCodeberg,
  buildGoModule,
  tailwindcss_4,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "rimgo";
  version = "1.4.2";

  src = fetchFromCodeberg {
    owner = "rimgo";
    repo = "rimgo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZdGPZFhjn7jsqHcj8neOocpDweB5TeYXNPfrDw2m7uY=";
  };

  vendorHash = "sha256-/aflGVI3M1dy6/5/CkQo1wPA59cb7m1XJcoF8nTm35Y=";

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
