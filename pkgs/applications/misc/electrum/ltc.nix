{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, wrapQtAppsHook
, python3
, zbar
, secp256k1
, enableQt ? true
# for updater.nix
, writeScript
, common-updater-scripts
, bash
, coreutils
, curl
, gnugrep
, gnupg
, gnused
, nix
}:

let
  version = "4.0.9.3";

  libsecp256k1_name =
    if stdenv.isLinux then "libsecp256k1.so.0"
    else if stdenv.isDarwin then "libsecp256k1.0.dylib"
    else "libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}";

  libzbar_name =
    if stdenv.isLinux then "libzbar.so.0"
    else "libzbar${stdenv.hostPlatform.extensions.sharedLibrary}";

  # Not provided in official source releases, which are what upstream signs.
  tests = fetchFromGitHub {
    owner = "pooler";
    repo = "electrum-ltc";
    rev = version;
    sha256 = "sha256-oZjQnrnj8nCaQjrIz8bWNt6Ib8Wu2ZMXHEPfCCy2fjk=";

    extraPostFetch = ''
      mv $out ./all
      mv ./all/electrum_ltc/tests $out
    '';
  };

  py = python3.override {
    packageOverrides = self: super: {

      aiorpcx = super.aiorpcx.overridePythonAttrs (oldAttrs: rec {
        version = "0.18.7";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1rswrspv27x33xa5bnhrkjqzhv0sknv5kd7pl1vidw9d2z4rx2l0";
        };
      });
    };
  };

in

python3.pkgs.buildPythonApplication {
  pname = "electrum-ltc";
  inherit version;

  src = fetchurl {
    url = "https://electrum-ltc.org/download/Electrum-LTC-${version}.tar.gz";
    sha256 = "sha256-+oox0BGqkvj0OGOKJF8tUoKdsZFeffNb6rTF8E8mo08=";
  };

  postUnpack = ''
    # can't symlink, tests get confused
    cp -ar ${tests} $sourceRoot/electrum_ltc/tests
  '';

  prePatch = ''
    substituteInPlace contrib/requirements/requirements.txt \
      --replace "dnspython>=2.0,<2.1" "dnspython>=2.0"

    # according to upstream, this is fine
    # https://github.com/spesmilo/electrum/issues/7361
    substituteInPlace contrib/requirements/requirements.txt \
      --replace "qdarkstyle<2.9" "qdarkstyle>=2.7"
  '';

  nativeBuildInputs = lib.optionals enableQt [ wrapQtAppsHook ];

  propagatedBuildInputs = with py.pkgs; [
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
    py_scrypt
    pysocks
    qrcode
    requests
    tlslite-ng
    # plugins
    btchip
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

  checkInputs = with python3.pkgs; [ pytestCheckHook pyaes pycryptodomex ];

  pytestFlagsArray = [ "electrum_ltc/tests" ];

  disabledTests = [
    "test_loop"  # test tries to bind 127.0.0.1 causing permission error
    "test_is_ip_address"  # fails spuriously https://github.com/spesmilo/electrum/issues/7307
  ];

  postCheck = ''
    $out/bin/electrum-ltc help >/dev/null
  '';

  passthru.updateScript = import ./update.nix {
    inherit lib;
    inherit
      writeScript
      common-updater-scripts
      bash
      coreutils
      curl
      gnupg
      gnugrep
      gnused
      nix
    ;
  };

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
