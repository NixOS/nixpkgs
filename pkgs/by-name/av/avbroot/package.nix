{ lib
, fetchFromGitHub
, rustPlatform
, gitUpdater
}:

rustPlatform.buildRustPackage rec {
  pname = "avbroot";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "chenxiaolong";
    repo = "avbroot";
    rev = "v${version}";
    hash = "sha256-RoeanW4vCFm7TCr8T8akNnDI10gqXsMjqq39Y/7LL9o=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "bzip2-0.4.4" = "sha256-9YKPFvaGNdGPn2mLsfX8Dh90vR+X4l3YSrsz0u4d+uQ=";
      "zip-0.6.6" = "sha256-oZQOW7xlSsb7Tw8lby4LjmySpWty9glcZfzpPuQSSz0=";
    };
  };

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "Sign (and root) Android A/B OTAs with custom keys while preserving Android Verified Boot";
    homepage = "https://github.com/chenxiaolong/avbroot";
    changelog = "https://github.com/chenxiaolong/avbroot/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; gpl3;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ mib ];
  };
}
