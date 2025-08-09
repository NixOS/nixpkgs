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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "patryk-ku";
    repo = "mpris-discord-rpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CzIHmc1BfKlUjiNjgslNDt00Xwpkz5zoDpYMd0HnHxE=";
  };

  cargoHash = "sha256-RUebfsAzn93a0Ebp6cmzZWj72ivkaPzEaN6RIP4/WQM=";

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
