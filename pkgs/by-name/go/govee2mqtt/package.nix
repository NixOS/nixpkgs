{
  rustPlatform,
  lib,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  fetchpatch,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  openssl,
  pkg-config,
}:

<<<<<<< HEAD
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "govee2mqtt";
  version = "2025.11.25-60a39bcc";
=======
rustPlatform.buildRustPackage rec {
  pname = "govee2mqtt";
  version = "2024.01.24-ea3cd430";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "wez";
    repo = "govee2mqtt";
<<<<<<< HEAD
    tag = finalAttrs.version;
    hash = "sha256-8N/qQHJvVKWdlPQDbLskGw9le0L7yzTwxwz1w4cFu5g=";
=======
    rev = version;
    hash = "sha256-iGOj0a4+wLd8QlM1tr+NYfd2tuwgHV+u5dt0zf+WscY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoPatches = [
    ./dont-vendor-openssl.diff
  ];

<<<<<<< HEAD
=======
  patches = [
    # update test fixtures https://github.com/wez/govee2mqtt/pull/120
    (fetchpatch {
      url = "https://github.com/wez/govee2mqtt/commit/0c2dc3e1cc1ccd44ddf98ead34e081ac4b4335f1.patch";
      hash = "sha256-0TNYyvRRcMkE9FYPcVoKburejhAn/cVYM3eaobS4nx8=";
    })
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  postPatch = ''
    substituteInPlace src/service/http.rs \
      --replace '"assets"' '"${placeholder "out"}/share/govee2mqtt/assets"'
  '';

<<<<<<< HEAD
  cargoHash = "sha256-rs3wfvotR2p7jC6dn+JkTLJxVBtQR/IWgM9KmoYSelA=";
=======
  cargoHash = "sha256-RJqAhAhrMHLunJwTtvUIBNO45xUWY251KXyX0RLruwk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  postInstall = ''
    mkdir -p $out/share/govee2mqtt/
    cp -r assets $out/share/govee2mqtt/
  '';

<<<<<<< HEAD
  meta = {
    description = "Connect Govee lights and devices to Home Assistant";
    homepage = "https://github.com/wez/govee2mqtt";
    changelog = "https://github.com/wez/govee2mqtt/blob/${finalAttrs.version}/addon/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "govee";
  };
})
=======
  meta = with lib; {
    description = "Connect Govee lights and devices to Home Assistant";
    homepage = "https://github.com/wez/govee2mqtt";
    changelog = "https://github.com/wez/govee2mqtt/blob/${src.rev}/addon/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "govee";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
