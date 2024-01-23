{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, wrapQtAppsHook
, python3
, zbar
, secp256k1
, enableQt ? true
, qtwayland
}:

let
  version = "4.2.2.1";

  libsecp256k1_name =
    if stdenv.isLinux then "libsecp256k1.so.0"
    else if stdenv.isDarwin then "libsecp256k1.0.dylib"
    else "libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}";

  libzbar_name =
    if stdenv.isLinux then "libzbar.so.0"
    else if stdenv.isDarwin then "libzbar.0.dylib"
    else "libzbar${stdenv.hostPlatform.extensions.sharedLibrary}";

  # Not provided in official source releases, which are what upstream signs.
  tests = fetchFromGitHub {
    owner = "pooler";
    repo = "electrum-ltc";
    rev = version;
    sha256 = "sha256-qu72LIV07pgHqvKv+Kcw9ZmNk6IBz+4/vdJELlT5tE4=";

    postFetch = ''
      mv $out ./all
      mv ./all/electrum_ltc/tests $out
    '';
  };

in

python3.pkgs.buildPythonApplication {
  pname = "electrum-ltc";
  inherit version;

  src = fetchurl {
    url = "https://electrum-ltc.org/download/Electrum-LTC-${version}.tar.gz";
    sha256 = "sha256-7F28cve+HD5JDK5igfkGD/NvTCfA33g+DmQJ5mwPM9Q=";
  };

  postUnpack = ''
    # can't symlink, tests get confused
    cp -ar ${tests} $sourceRoot/electrum_ltc/tests
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
    py-scrypt
    pysocks
    qrcode
    requests
    tlslite-ng
    certifi
    # plugins
    btchip-python
    ckcc-protocol
    keepkey
    trezor
  ] ++ lib.optionals enableQt [
    pyqt5
    qdarkstyle
  ];

  preBuild = ''
    sed -i 's,usr_share = .*,usr_share = "'$out'/share",g' setup.py
    substituteInPlace ./electrum_ltc/ecc_fast.py \
      --replace ${libsecp256k1_name} ${secp256k1}/lib/libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}
  '' + (if enableQt then ''
    substituteInPlace ./electrum_ltc/qrscanner.py \
      --replace ${libzbar_name} ${zbar.lib}/lib/libzbar${stdenv.hostPlatform.extensions.sharedLibrary}
  '' else ''
    sed -i '/qdarkstyle/d' contrib/requirements/requirements.txt
  '');

  postInstall = lib.optionalString stdenv.isLinux ''
    # Despite setting usr_share above, these files are installed under
    # $out/nix ...
    mv $out/${python3.sitePackages}/nix/store"/"*/share $out
    rm -rf $out/${python3.sitePackages}/nix

    substituteInPlace $out/share/applications/electrum-ltc.desktop \
      --replace 'Exec=sh -c "PATH=\"\\$HOME/.local/bin:\\$PATH\"; electrum-ltc %u"' \
                "Exec=$out/bin/electrum-ltc %u" \
      --replace 'Exec=sh -c "PATH=\"\\$HOME/.local/bin:\\$PATH\"; electrum-ltc --testnet %u"' \
                "Exec=$out/bin/electrum-ltc --testnet %u"

  '';

  postFixup = lib.optionalString enableQt ''
    wrapQtApp $out/bin/electrum-ltc
  '';

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook pyaes pycryptodomex ];
  buildInputs = lib.optional stdenv.isLinux qtwayland;

  pytestFlagsArray = [ "electrum_ltc/tests" ];

  disabledTests = [
    "test_loop"  # test tries to bind 127.0.0.1 causing permission error
    "test_is_ip_address"  # fails spuriously https://github.com/spesmilo/electrum/issues/7307
  ];

  postCheck = ''
    $out/bin/electrum-ltc help >/dev/null
  '';

  meta = with lib; {
    description = "Lightweight Litecoin Client";
    longDescription = ''
      Electrum-LTC is a simple, but powerful Litecoin wallet. A unique secret
      phrase (or “seed”) leaves intruders stranded and your peace of mind
      intact. Keep it on paper, or in your head... and never worry about losing
      your litecoins to theft or hardware failure.
    '';
    homepage = "https://electrum-ltc.org/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ lourkeur ];
  };
}
