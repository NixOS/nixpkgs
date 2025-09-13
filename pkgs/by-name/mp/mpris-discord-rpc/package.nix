{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  openssl,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mpris-discord-rpc";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "patryk-ku";
    repo = "mpris-discord-rpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tPIm07q5HWosqhA3zefyuwM+fIztNZe1sSpB/NmUIoE=";
  };

  cargoHash = "sha256-3MJAvCc0ekUQ+eM5n8MdPNxXJWUgV76vi/Rq7GhhEPE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    openssl
  ];

  postInstall = ''
    mkdir --parents $out/etc/systemd/user
    substitute $src/mpris-discord-rpc.service $out/etc/systemd/user/mpris-discord-rpc.service \
      --replace-fail /usr/bin/mpris-discord-rpc $out/bin/mpris-discord-rpc
  '';

  meta = {
    description = "Linux Discord rich presence for music, using MPRIS with album cover and progress bar support";
    homepage = "https://github.com/patryk-ku/mpris-discord-rpc";
    changelog = "https://github.com/patryk-ku/mpris-discord-rpc/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lukaswrz ];
    mainProgram = "mpris-discord-rpc";
  };
})
