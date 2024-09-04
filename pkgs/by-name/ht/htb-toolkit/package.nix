{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
, coreutils
, gnome-keyring
, libsecret
, openvpn
, gzip
, killall
}:

rustPlatform.buildRustPackage {
  pname = "htb-toolkit";
  version = "0-unstable-2024-04-22";

  src = fetchFromGitHub {
    owner = "D3vil0p3r";
    repo = "htb-toolkit";
    # https://github.com/D3vil0p3r/htb-toolkit/issues/3
    rev = "921e4b352a9dd8b3bc8ac8774e13509abd179aef";
    hash = "sha256-o91p/m06pm9qoYZZVh+qHulqHO2G7xVJQPpEvRsq+8Q=";
  };

  cargoHash = "sha256-vTUiagI0eTrADr6zCMI5btLRvXgZSaohldg4jYmjfyA=";

  # Patch to disable prompt change of the shell when a target machine is run. Needed due to Nix declarative nature
  patches = [
    ./disable-shell-prompt-change.patch
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isLinux [
    gnome-keyring
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  postPatch = ''
    substituteInPlace src/manage.rs \
      --replace-fail /usr/share/icons/htb-toolkit/ $out/share/icons/htb-toolkit/
    substituteInPlace src/utils.rs \
      --replace-fail "\"base64\"" "\"${coreutils}/bin/base64\"" \
      --replace-fail "\"gunzip\"" "\"${gzip}/bin/gunzip\""
    substituteInPlace src/appkey.rs \
      --replace-fail secret-tool ${lib.getExe libsecret}
    substituteInPlace src/vpn.rs \
      --replace-fail "arg(\"openvpn\")" "arg(\"${openvpn}/bin/openvpn\")" \
      --replace-fail "arg(\"killall\")" "arg(\"${killall}/bin/killall\")"
  '';

  meta = with lib; {
    description = "Play Hack The Box directly on your system";
    mainProgram = "htb-toolkit";
    homepage = "https://github.com/D3vil0p3r/htb-toolkit";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
}
