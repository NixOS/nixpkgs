{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "bazarr-sync";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "ajmandourah";
    repo = "bazarr-sync";
    rev = "v${version}";
    hash = "sha256-WyZmuXq0LVyT/6zpIfWyC+i6KIKGVryC1kaCNiQtG64=";
  };

  vendorHash = "sha256-0K5uBgJ4/QXGd17iNuenB6nXiY2DZn5PIs1jdd10sCs=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bulk sync your subtitles via Bazarr";
    homepage = "https://github.com/ajmandourah/bazarr-sync";
    # fix once upstream has a LICENSE
    # https://github.com/ajmandourah/bazarr-sync/issues/15
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ eyjhb ];
    mainProgram = "bazarr-sync";
  };
}
