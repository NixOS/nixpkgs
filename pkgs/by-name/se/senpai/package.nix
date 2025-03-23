{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  installShellFiles,
  scdoc,
  nix-update-script,
}:

buildGoModule rec {
  pname = "senpai";
  version = "0.4.0";

  src = fetchFromSourcehut {
    owner = "~delthas";
    repo = "senpai";
    rev = "v${version}";
    sha256 = "sha256-3DVy+7mMVFmPpGxwJqtt2+QwNEMrgZazynawE/Wf+UM=";
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
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Your everyday IRC student";
    mainProgram = "senpai";
    homepage = "https://sr.ht/~delthas/senpai/";
    changelog = "https://git.sr.ht/~delthas/senpai/refs/v${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ malte-v ];
  };
}
