{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  installShellFiles,
  scdoc,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "senpai";
  version = "0.4.1";

  src = fetchFromSourcehut {
    owner = "~delthas";
    repo = "senpai";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-lwfhRnaHGOIp6NyugPEu6P+3WXkVgQEWaz7DUfHiJrQ=";
  };

  vendorHash = "sha256-6glslBPjJr0TmrAkDGbOQ4sDzvODlavVeTugs6RXsCU=";

  subPackages = [
    "cmd/senpai"
  ];

  nativeBuildInputs = [
    scdoc
    installShellFiles
  ];

  postInstall = ''
    scdoc < doc/senpai.1.scd > doc/senpai.1
    scdoc < doc/senpai.5.scd > doc/senpai.5
    installManPage doc/senpai.*
    install -D -m 444 -t $out/share/applications contrib/senpai.desktop
    install -D -m 444 res/icon.48.png $out/share/icons/hicolor/48x48/apps/senpai.png
    install -D -m 444 res/icon.128.png $out/share/icons/hicolor/128x128/apps/senpai.png
    install -D -m 444 res/icon.svg $out/share/icons/hicolor/scalable/apps/senpai.svg
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Your everyday IRC student";
    mainProgram = "senpai";
    homepage = "https://sr.ht/~delthas/senpai/";
    changelog = "https://git.sr.ht/~delthas/senpai/refs/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ malte-v ];
  };
})
