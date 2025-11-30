{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  wrapQtAppsHook,
  python3,
  zbar,
  enableQt ? true,
  qtwayland,
}:

let
  version = "4.6.2-3";

  libzbar_name =
    if stdenv.hostPlatform.isLinux then
      "libzbar.so.0"
    else if stdenv.hostPlatform.isDarwin then
      "libzbar.0.dylib"
    else
      "libzbar${stdenv.hostPlatform.extensions.sharedLibrary}";

in

python3.pkgs.buildPythonApplication {
  pname = "electrum-ltc";
  inherit version;
  format = "setuptools";

  src = fetchurl {
    url = "https://github.com/ltc-electrum/electrum-ltc/releases/download/${version}/Electrum-LTC-4.6.2.tar.gz";
    hash = "sha256-u/iHczEAla0MiAuqzxlmbdvwrn2ygrhQdW8mRJbIzbc=";
  };

  nativeBuildInputs = lib.optionals enableQt [ wrapQtAppsHook ];

  propagatedBuildInputs =
    with python3.pkgs;
    [
      aiohttp
      aiohttp-socks
      aiorpcx
      attrs
      bitstring
      certifi
      cryptography
      dnspython
      electrum-ecc
      electrum-aionostr
      grpcio
      pytest-qt
      jaraco-path
      jsonrpclib-pelix
      jsonpatch
      matplotlib
      pbkdf2
      protobuf
      pysocks
      qrcode
      requests
      scrypt
      # plugins
      btchip-python
      ckcc-protocol
      keepkey
      trezor
      distutils
    ]
    ++ lib.optionals enableQt [
      pyqt6
      qdarkstyle
    ];

  postPatch = ''
    # copy the patched `/run_electrum` over `/electrum/electrum`
    # so the aiorpcx compatibility patch is used
    cp run_electrum electrum/electrum-ltc

    # refresh stale generated code, per electrum/paymentrequest.py line 40
    protoc --proto_path=electrum/ --python_out=electrum/ electrum/paymentrequest.proto
  '';

  preBuild =
    if enableQt then
      ''
        substituteInPlace ./electrum/qrscanner.py \
          --replace ${libzbar_name} ${zbar.lib}/lib/libzbar${stdenv.hostPlatform.extensions.sharedLibrary}
      ''
    else
      ''
        sed -i '/qdarkstyle/d' contrib/requirements/requirements.txt
      '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $out/share/applications/electrum-ltc.desktop \
      --replace 'Exec=sh -c "PATH=\"\\$HOME/.local/bin:\\$PATH\"; electrum-ltc %u"' \
                "Exec=$out/bin/electrum-ltc %u" \
      --replace 'Exec=sh -c "PATH=\"\\$HOME/.local/bin:\\$PATH\"; electrum-ltc --testnet %u"' \
                "Exec=$out/bin/electrum-ltc --testnet %u"

  '';

  postFixup = lib.optionalString enableQt ''
    wrapQtApp $out/bin/electrum-ltc
  '';

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pyaes
    pycryptodomex
  ];
  buildInputs = lib.optional stdenv.hostPlatform.isLinux qtwayland;

  enabledTestPaths = [ "tests" ];

  disabledTests = [
    "test_loop" # test tries to bind 127.0.0.1 causing permission error
    "test_is_ip_address" # fails spuriously https://github.com/spesmilo/electrum/issues/7307
    # electrum_ltc.lnutil.RemoteMisbehaving: received commitment_signed without pending changes
    "test_reestablish_replay_messages_rev_then_sig"
    "test_reestablish_replay_messages_sig_then_rev"
    # stuck on hydra
    "test_reestablish_with_old_state"
  ];

  postCheck = ''
    $out/bin/electrum-ltc help >/dev/null
  '';

  meta = with lib; {
    description = "Lightweight Litecoin Client";
    mainProgram = "electrum-ltc";
    longDescription = ''
      Electrum-LTC is a simple, but powerful Litecoin wallet. A unique secret
      phrase (or “seed”) leaves intruders stranded and your peace of mind
      intact. Keep it on paper, or in your head... and never worry about losing
      your litecoins to theft or hardware failure.
    '';
    homepage = "https://ltc-electrum.github.io/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ bbjubjub ];
  };
}
