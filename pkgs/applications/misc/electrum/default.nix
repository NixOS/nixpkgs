{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, wrapQtAppsHook
, python3
, zbar
, secp256k1
, enableQt ? true
, callPackage
, qtwayland
, fetchPypi
}:

let
  version = "4.5.5";

  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      # Pin ledger-bitcoin to 0.2.1
      ledger-bitcoin = super.ledger-bitcoin.overridePythonAttrs (oldAttrs: rec {
        version = "0.2.1";
        format = "pyproject";
        src = fetchPypi {
          pname = "ledger_bitcoin";
          inherit version;
          hash = "sha256-AWl/q2MzzspNIo6yf30S92PgM/Ygsb+1lJsg7Asztso=";
        };
      });
    };
  };

  libsecp256k1_name =
    if stdenv.isLinux then "libsecp256k1.so.{v}"
    else if stdenv.isDarwin then "libsecp256k1.{v}.dylib"
    else "libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}";

  libzbar_name =
    if stdenv.isLinux then "libzbar.so.0"
    else if stdenv.isDarwin then "libzbar.0.dylib"
    else "libzbar${stdenv.hostPlatform.extensions.sharedLibrary}";

  # Not provided in official source releases, which are what upstream signs.
  tests = fetchFromGitHub {
    owner = "spesmilo";
    repo = "electrum";
    rev = version;
    sha256 = "sha256-CbhI/q+zjk9odxuvdzpogi046FqkedJooiQwS+WAkJ8=";

    postFetch = ''
      mv $out ./all
      mv ./all/tests $out
    '';
  };

in

python.pkgs.buildPythonApplication {
  pname = "electrum";
  inherit version;

  src = fetchurl {
    url = "https://download.electrum.org/${version}/Electrum-${version}.tar.gz";
    sha256 = "1jiagz9avkbd158pcip7p4wz0pdsxi94ndvg5p8afvshb32aqwav";
  };

  postUnpack = ''
    # can't symlink, tests get confused
    cp -ar ${tests} $sourceRoot/tests
  '';

  nativeBuildInputs = lib.optionals enableQt [ wrapQtAppsHook ];
  buildInputs = lib.optional (stdenv.isLinux && enableQt) qtwayland;

  propagatedBuildInputs = with python.pkgs; [
    aiohttp
    aiohttp-socks
    aiorpcx
    attrs
    bitstring
    cryptography
    dnspython
    jsonrpclib-pelix
    matplotlib
    pbkdf2
    protobuf
    pysocks
    qrcode
    requests
    certifi
    jsonpatch
    # plugins
    btchip-python
    ledger-bitcoin
    ckcc-protocol
    keepkey
    trezor
    bitbox02
    cbor2
    pyserial
  ] ++ lib.optionals enableQt [
    pyqt5
    qdarkstyle
  ];

  checkInputs = with python.pkgs; lib.optionals enableQt [
    pyqt6
  ];

  postPatch = ''
    # make compatible with protobuf4 by easing dependencies ...
    substituteInPlace ./contrib/requirements/requirements.txt \
      --replace "protobuf>=3.20,<4" "protobuf>=3.20"
    # ... and regenerating the paymentrequest_pb2.py file
    protoc --python_out=. electrum/paymentrequest.proto

    substituteInPlace ./electrum/ecc_fast.py \
      --replace ${libsecp256k1_name} ${secp256k1}/lib/libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}
  '' + (if enableQt then ''
    substituteInPlace ./electrum/qrscanner.py \
      --replace ${libzbar_name} ${zbar.lib}/lib/libzbar${stdenv.hostPlatform.extensions.sharedLibrary}
  '' else ''
    sed -i '/qdarkstyle/d' contrib/requirements/requirements.txt
  '');

  postInstall = lib.optionalString stdenv.isLinux ''
    substituteInPlace $out/share/applications/electrum.desktop \
      --replace 'Exec=sh -c "PATH=\"\\$HOME/.local/bin:\\$PATH\"; electrum %u"' \
                "Exec=$out/bin/electrum %u" \
      --replace 'Exec=sh -c "PATH=\"\\$HOME/.local/bin:\\$PATH\"; electrum --testnet %u"' \
                "Exec=$out/bin/electrum --testnet %u"
  '';

  postFixup = lib.optionalString enableQt ''
    wrapQtApp $out/bin/electrum
  '';

  nativeCheckInputs = with python.pkgs; [ pytestCheckHook pyaes pycryptodomex ];

  pytestFlagsArray = [ "tests" ];

  postCheck = ''
    $out/bin/electrum help >/dev/null
  '';

  passthru.updateScript = callPackage ./update.nix { };

  meta = with lib; {
    description = "Lightweight Bitcoin wallet";
    longDescription = ''
      An easy-to-use Bitcoin client featuring wallets generated from
      mnemonic seeds (in addition to other, more advanced, wallet options)
      and the ability to perform transactions without downloading a copy
      of the blockchain.
    '';
    homepage = "https://electrum.org/";
    downloadPage = "https://electrum.org/#download";
    changelog = "https://github.com/spesmilo/electrum/blob/master/RELEASE-NOTES";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ joachifm np prusnak chewblacka ];
    mainProgram = "electrum";
  };
}
