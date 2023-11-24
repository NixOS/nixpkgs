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
}:

let
  version = "4.4.6";

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
    sha256 = "sha256-nd435CgF0a6JOni/OXcxkciVCR1aQqzfGfDSg1gPQ8Q=";

    postFetch = ''
      mv $out ./all
      mv ./all/electrum/tests $out
    '';
  };

in

python3.pkgs.buildPythonApplication {
  pname = "electrum";
  inherit version;

  src = fetchurl {
    url = "https://download.electrum.org/${version}/Electrum-${version}.tar.gz";
    sha256 = "sha256-BxxC1xVKToUjgBo4mEeK9Tdhbd/+doHcTTJsXDtaELg=";
  };

  postUnpack = ''
    # can't symlink, tests get confused
    cp -ar ${tests} $sourceRoot/electrum/tests
  '';

  nativeBuildInputs = lib.optionals enableQt [ wrapQtAppsHook ];

  propagatedBuildInputs = with python3.pkgs; [
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
    tlslite-ng
    # plugins
    btchip-python
    ledger-bitcoin
    ckcc-protocol
    keepkey
    trezor
  ] ++ lib.optionals enableQt [
    pyqt5
    qdarkstyle
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

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook pyaes pycryptodomex ];

  pytestFlagsArray = [ "electrum/tests" ];

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
    maintainers = with maintainers; [ joachifm np prusnak ];
  };
}
