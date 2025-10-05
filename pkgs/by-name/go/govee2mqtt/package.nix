{
  rustPlatform,
  lib,
  fetchFromGitHub,
  fetchpatch,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "govee2mqtt";
  version = "2024.01.24-ea3cd430";

  src = fetchFromGitHub {
    owner = "wez";
    repo = "govee2mqtt";
    rev = version;
    hash = "sha256-iGOj0a4+wLd8QlM1tr+NYfd2tuwgHV+u5dt0zf+WscY=";
  };

  cargoPatches = [
    ./dont-vendor-openssl.diff
  ];

  patches = [
    # update test fixtures https://github.com/wez/govee2mqtt/pull/120
    (fetchpatch {
      url = "https://github.com/wez/govee2mqtt/commit/0c2dc3e1cc1ccd44ddf98ead34e081ac4b4335f1.patch";
      hash = "sha256-0TNYyvRRcMkE9FYPcVoKburejhAn/cVYM3eaobS4nx8=";
    })
  ];

  postPatch = ''
    substituteInPlace src/service/http.rs \
      --replace '"assets"' '"${placeholder "out"}/share/govee2mqtt/assets"'
  '';

  cargoHash = "sha256-RJqAhAhrMHLunJwTtvUIBNO45xUWY251KXyX0RLruwk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  postInstall = ''
    mkdir -p $out/share/govee2mqtt/
    cp -r assets $out/share/govee2mqtt/
  '';

  meta = with lib; {
    description = "Connect Govee lights and devices to Home Assistant";
    homepage = "https://github.com/wez/govee2mqtt";
    changelog = "https://github.com/wez/govee2mqtt/blob/${src.rev}/addon/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "govee";
  };
}
