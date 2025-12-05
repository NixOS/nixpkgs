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
  version = "0-unstable-2025-08-12";

  src = fetchFromGitHub {
    owner = "D3vil0p3r";
    repo = "htb-toolkit";
    # https://github.com/D3vil0p3r/htb-toolkit/issues/3
    rev = "60996a88fbd5e8aeab78005e754ef37d95ffdba4";
    hash = "sha256-u+IigAs/W0lzp9kCW43TkjHTIrPCkGdmva6tesQq/Pk=";
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

  meta = with lib; {
    description = "Play Hack The Box directly on your system";
    mainProgram = "htb-toolkit";
    homepage = "https://github.com/D3vil0p3r/htb-toolkit";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
}
