{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, fetchpatch
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
  version = "4.1.5";

  libsecp256k1_name =
    if stdenv.isLinux then "libsecp256k1.so.0"
    else if stdenv.isDarwin then "libsecp256k1.0.dylib"
    else "libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}";

  libzbar_name =
    if stdenv.isLinux then "libzbar.so.0"
    else "libzbar${stdenv.hostPlatform.extensions.sharedLibrary}";

  # Not provided in official source releases, which are what upstream signs.
  tests = fetchFromGitHub {
    owner = "spesmilo";
    repo = "electrum";
    rev = version;
    sha256 = "1ps8yaps5kfd7yv7bpdvssbwm6f5qivxcvhwn17cpddc2760a7nk";

    extraPostFetch = ''
      mv $out ./all
      mv ./all/electrum/tests $out
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
  pname = "electrum";
  inherit version;

  src = fetchurl {
    url = "https://download.electrum.org/${version}/Electrum-${version}.tar.gz";
    sha256 = "188r4zji985z8pm9b942xhmvv174yndk6jxagxl7ljk03wl2wiwi";
  };

  postUnpack = ''
    # can't symlink, tests get confused
    cp -ar ${tests} $sourceRoot/electrum/tests
  '';

  postPatch = ''
    substituteInPlace contrib/requirements/requirements.txt \
      --replace "dnspython>=2.0,<2.1" "dnspython>=2.0"
  '';

  patches = [
    # trezorlib 0.13 compatibility
    (fetchpatch {
      url = "https://github.com/spesmilo/electrum/commit/97e61cfacdca374103e4184f0f9a07a0c5757afb.patch";
      sha256 = "sha256-RGVBO9IskC+lQOHNGjrqH6EM/inNPJlcD9sSWedyT5E=";
    })
  ];

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
    substituteInPlace ./electrum/ecc_fast.py \
      --replace ${libsecp256k1_name} ${secp256k1}/lib/libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}
  '' + (if enableQt then ''
    substituteInPlace ./electrum/qrscanner.py \
      --replace ${libzbar_name} ${zbar.lib}/lib/libzbar${stdenv.hostPlatform.extensions.sharedLibrary}
  '' else ''
    sed -i '/qdarkstyle/d' contrib/requirements/requirements.txt
  '');

  postInstall = lib.optionalString stdenv.isLinux ''
    # Despite setting usr_share above, these files are installed under
    # $out/nix ...
    mv $out/${python3.sitePackages}/nix/store"/"*/share $out
    rm -rf $out/${python3.sitePackages}/nix

    substituteInPlace $out/share/applications/electrum.desktop \
      --replace 'Exec=sh -c "PATH=\"\\$HOME/.local/bin:\\$PATH\"; electrum %u"' \
                "Exec=$out/bin/electrum %u" \
      --replace 'Exec=sh -c "PATH=\"\\$HOME/.local/bin:\\$PATH\"; electrum --testnet %u"' \
                "Exec=$out/bin/electrum --testnet %u"

  '';

  postFixup = lib.optionalString enableQt ''
    wrapQtApp $out/bin/electrum
  '';

  checkInputs = with python3.pkgs; [ pytestCheckHook pyaes pycryptodomex ];

  pytestFlagsArray = [ "electrum/tests" ];

  disabledTests = [
    "test_loop"  # test tries to bind 127.0.0.1 causing permission error
  ];

  postCheck = ''
    $out/bin/electrum help >/dev/null
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
    description = "A lightweight Bitcoin wallet";
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
