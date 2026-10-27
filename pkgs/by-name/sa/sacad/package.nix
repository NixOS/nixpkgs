{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sacad";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "sacad";
    tag = finalAttrs.version;
    hash = "sha256-ViiIDkew1C2leADGbGldtKfAenafABP2UUlMzaj4ixA=";
  };

  cargoHash = "sha256-39xtrZbTZPsNQ7rvgftaH6kSPF/qjQMzwuAmbj47j08=";

  # Tests require internet connection.
  doCheck = false;

  meta = {
    description = "Smart Automatic Cover Art Downloader";
    homepage = "https://github.com/desbma/sacad";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ moni ];
    mainProgram = "sacad";
  };
})
