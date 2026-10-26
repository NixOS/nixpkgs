{
  lib,
  ocamlPackages,
  fetchFromGitHub,
  scdoc,
}:

ocamlPackages.buildDunePackage (finalAttrs: {
  pname = "spatial-shell";
  version = "7";

  src = fetchFromGitHub {
    owner = "lthms";
    repo = "spatial-shell";
    rev = finalAttrs.version;
    hash = "sha256-OeNBP/jea1ABh/WpvCP7We+L20WoTfLZH71raH7bKPI=";
  };

  nativeBuildInputs = [
    scdoc
  ];

  buildInputs = with ocamlPackages; [
    cmdliner
    ezjsonm-encoding
    poll
  ];

  meta = {
    description = "Implementing a spatial model inspired by Material Shell, for i3 and sway";
    homepage = "https://github.com/lthms/spatial-shell";
    changelog = "https://github.com/lthms/spatial-shell/blob/${finalAttrs.src.rev}/CHANGES.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "spatial";
    platforms = lib.platforms.linux;
  };
})
