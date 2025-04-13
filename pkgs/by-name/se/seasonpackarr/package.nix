{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "seasonpackarr";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "nuxencs";
    repo = "seasonpackarr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-l9cnjXCONz3w85ffXJSuraqGmKoC2kEGS1utz5MoZvc=";
  };

  vendorHash = "sha256-zwGBsORzO8SvxoHU3Cry99vUraM9ZERyRhtjPwGq4GY=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/nuxencs/seasonpackarr/internal/buildinfo.Version=v${finalAttrs.version}"
    "-X github.com/nuxencs/seasonpackarr/internal/buildinfo.Commit=v${finalAttrs.version}"
    "-X github.com/nuxencs/seasonpackarr/internal/buildinfo.Date=unknown"
  ];

  checkFlags = [
    # Tries to make API calls
    "-skip=^Test_TVMaze"
  ];

  passthru = {
    updateScript = nix-update-script;
  };

  meta = with lib; {
    description = "Automagically hardlink downloaded episodes into a season folder";
    homepage = "https://github.com/nuxencs/seasonpackarr";
    maintainers = with maintainers; [ ambroisie ];
    license = licenses.gpl2Plus;
    mainProgram = "seasonpackarr";
  };
})
