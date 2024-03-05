{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
, coreutils
, gnome
, libsecret
, bash
, openvpn
, nerdfonts
, gzip
, killall
}:

rustPlatform.buildRustPackage {
  pname = "htb-toolkit";
  version = "unstable-2024-01-17";

  src = fetchFromGitHub {
    owner = "D3vil0p3r";
    repo = "htb-toolkit";
    # https://github.com/D3vil0p3r/htb-toolkit/issues/3
    rev = "54e11774ea8746ea540548082d3b25c22306b4fc";
    hash = "sha256-QYUqdqFV9Qn+VbJTnz5hx5I0XV1nrzCoCKtRS7jBLsE=";
  };

  cargoHash = "sha256-XDE6A6EIAUbuzt8Zb/ROfDAPp0ZyN0WQ4D1gWHjRVhg=";

  # Patch to disable prompt change of the shell when a target machine is run. Needed due to Nix declarative nature
  patches = [
    ./disable-shell-prompt-change.patch
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gnome.gnome-keyring
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  postPatch = ''
    substituteInPlace src/manage.rs \
      --replace /usr/share/htb-toolkit/icons/ $out/share/htb-toolkit/icons/
    substituteInPlace src/utils.rs \
      --replace /usr/bin/bash ${bash} \
      --replace "\"base64\"" "\"${coreutils}/bin/base64\"" \
      --replace "\"gunzip\"" "\"${gzip}/bin/gunzip\""
    substituteInPlace src/appkey.rs \
      --replace secret-tool ${lib.getExe libsecret}
    substituteInPlace src/vpn.rs \
      --replace "arg(\"openvpn\")" "arg(\"${openvpn}/bin/openvpn\")" \
      --replace "arg(\"killall\")" "arg(\"${killall}/bin/killall\")"
  '';

  meta = with lib; {
    description = "Play Hack The Box directly on your system";
    homepage = "https://github.com/D3vil0p3r/htb-toolkit";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ d3vil0p3r ];
    mainProgram = "htb-toolkit";
  };
}
