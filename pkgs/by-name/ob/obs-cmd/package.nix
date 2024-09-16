{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "obs-cmd";
  version = "0.17.8";

  src = fetchFromGitHub {
    owner = "grigio";
    repo = "obs-cmd";
    rev = "v${version}";
    hash = "sha256-IOGdy3X0/r/kuEXAvLeJk2HXtcGI+vbh4Dn1/yOpkmM=";
  };

  cargoHash = "sha256-oCu/ygjZxEqxE+5Vca3l1mZP3hd+r+5gi2iogQMnEcU=";

  meta = with lib; {
    description = "Minimal CLI to control OBS Studio via obs-websocket";
    homepage = "https://github.com/grigio/obs-cmd";
    changelog = "https://github.com/grigio/obs-cmd/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ ianmjones ];
    mainProgram = "obs-cmd";
  };
}
