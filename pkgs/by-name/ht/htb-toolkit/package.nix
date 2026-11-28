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
  version = "0-unstable-2026-10-30";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "htb-toolkit";
    rev = "07ed6e36c47fda386b5fdb138d57e92cbcfc5206";
    sha256 = "sha256-SlXpFn3Aim+EN95aLD36Ez+PiPyto1tPKs4Vu6bg/5U=";
  };

  cargoHash = "sha256-ReEe8pyW66GXIPwAy6IKsFEAUjxHmzw5mj21i/h4quQ=";

  # Patch to disable prompt change of the shell when a target machine is run. Needed due to Nix declarative nature
  # Patches are disabled for 1.0.0 as the shell prompt feature was refactored
  patches = [
    # ./disable-shell-prompt-change.patch
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
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

  passthru.updateScript = unstableGitUpdater {};

  meta = {
    description = "Play Hack The Box directly on your system";
    mainProgram = "htb-toolkit";
    homepage = "https://github.com/Athena-OS/htb-toolkit";
    maintainers = [];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3Plus;
  };
}
