{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "luminous-ttv";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "AlyoshaVasilieva";
    repo = "luminous-ttv";
    rev = "v${version}";
    hash = "sha256-pT+hiREKdzw9MKv28QpLK6LmHvnRci26f0DlcXns2rA=";
  };

  cargoHash = "sha256-A5fUATbOuwSt0n1KV/+bbd65mDwWhllGraf2RrBTK6s=";

  meta = {
    description = "Rust server to retrieve and relay a playlist for Twitch livestreams/VODs";
    homepage = "https://github.com/AlyoshaVasilieva/luminous-ttv";
    downloadPage = "https://github.com/AlyoshaVasilieva/luminous-ttv/releases/latest";
    changelog = "https://github.com/AlyoshaVasilieva/luminous-ttv/releases/tag/v${version}";
    license = with lib.licenses; [
      gpl3Only
      mit
    ];
    mainProgram = "luminous-ttv";
    maintainers = with lib.maintainers; [ alex ];
  };
}
