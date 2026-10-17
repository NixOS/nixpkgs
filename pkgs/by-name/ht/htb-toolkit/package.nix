{
  lib,
  rustPlatform,
  fetchFromGitHub,
  unstableGitUpdater,
  pkg-config,
  openssl,
  stdenv,
  coreutils,
  gnome-keyring,
  libsecret,
  openvpn,
  gzip,
  killall,
}:

rustPlatform.buildRustPackage {
  pname = "htb-toolkit";
  version = "1.0.0-unstable-2026-07-14";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "htb-toolkit";
    # https://github.com/D3vil0p3r/htb-toolkit/issues/3
    rev = "9edd01f98df4f666e38aaf9aa1a9c070b8d35e9a";
    hash = "sha256-i+/gAWtGCIKYJlrS9bolQOy9LDJgMapH6xHmFci5pO0=";
  };

  cargoHash = "sha256-ReEe8pyW66GXIPwAy6IKsFEAUjxHmzw5mj21i/h4quQ=";

  # Patch to disable prompt change of the shell when a target machine is run. Needed due to Nix declarative nature
  patches = [
    ./disable-shell-prompt-change.patch
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gnome-keyring
  ];

  postPatch = ''
    substituteInPlace src/utils.rs \
      --replace-fail "\"base64\"" "\"${coreutils}/bin/base64\"" \
      --replace-fail "\"gunzip\"" "\"${gzip}/bin/gunzip\""
    substituteInPlace src/appkey.rs \
      --replace-fail secret-tool ${lib.getExe libsecret}
    substituteInPlace src/vpn.rs \
      --replace-fail "arg(\"openvpn\")" "arg(\"${openvpn}/bin/openvpn\")" \
      --replace-fail "arg(\"killall\")" "arg(\"${killall}/bin/killall\")"
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Play Hack The Box directly on your system";
    mainProgram = "htb-toolkit";
    homepage = "https://github.com/Athena-OS/htb-toolkit";
    maintainers = with lib.maintainers; [ d3vil0p3r ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3Plus;
  };
}
