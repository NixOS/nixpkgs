{
  lib,
  rustPlatform,
  fetchFromGitHub,
<<<<<<< HEAD
  unstableGitUpdater,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "0-unstable-2025-12-19";
=======
  version = "0-unstable-2025-03-15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "D3vil0p3r";
    repo = "htb-toolkit";
    # https://github.com/D3vil0p3r/htb-toolkit/issues/3
<<<<<<< HEAD
    rev = "4f1c6bded11d8c907c951fcbe63f1fc44568a9f9";
    hash = "sha256-pkZ5KVSgtrWfXhJ3knmyOIArIjyAjMmm5WcrrB2pCKY=";
=======
    rev = "dd193c2974cd5fd1bbc6f7f616ebd597e28539ec";
    hash = "sha256-NTZv0BPyIB32CNXbINYTy4n8tNVJ3pRLr1QDhI/tg2Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
    substituteInPlace src/manage.rs \
      --replace-fail /usr/share/icons/htb-toolkit/ $out/share/icons/htb-toolkit/
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    substituteInPlace src/utils.rs \
      --replace-fail "\"base64\"" "\"${coreutils}/bin/base64\"" \
      --replace-fail "\"gunzip\"" "\"${gzip}/bin/gunzip\""
    substituteInPlace src/appkey.rs \
      --replace-fail secret-tool ${lib.getExe libsecret}
    substituteInPlace src/vpn.rs \
      --replace-fail "arg(\"openvpn\")" "arg(\"${openvpn}/bin/openvpn\")" \
      --replace-fail "arg(\"killall\")" "arg(\"${killall}/bin/killall\")"
  '';

<<<<<<< HEAD
  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Play Hack The Box directly on your system";
    mainProgram = "htb-toolkit";
    homepage = "https://github.com/D3vil0p3r/htb-toolkit";
    maintainers = with lib.maintainers; [ d3vil0p3r ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3Plus;
=======
  meta = with lib; {
    description = "Play Hack The Box directly on your system";
    mainProgram = "htb-toolkit";
    homepage = "https://github.com/D3vil0p3r/htb-toolkit";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
