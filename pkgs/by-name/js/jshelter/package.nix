{ callPackage
, lib
, fetchurl
, fetchgit
, stdenv

  # dependencies
, doxygen
, freefont_ttf
, graphviz
, makeFontsConf
, nodejs
, zip
}:

let
  version = "0.18";

  ipv4csv = fetchurl {
    url = "https://www.iana.org/assignments/locally-served-dns-zones/ipv4.csv";
    hash = "sha256-NYsxbG0WecF0+BO7hFlgmAACtDfL8P5PB556Z8iarms=";
  };
  ipv6csv = fetchurl {
    url = "https://www.iana.org/assignments/locally-served-dns-zones/ipv6.csv";
    hash = "sha256-9ImunHzGKDZACTknDe86EwUHZv2DS1g9U+ofDC3Pa20=";
  };

  src = fetchgit {
    url = "https://pagure.io/JShelter/webextension.git";
    rev = version;
    hash = "sha256-Dw+pI6tn76pYLljbHhW2Xx6rhClYlZlX9MBF4OM24SU=";
  };

  jshelter-wasm = callPackage ./wasm.nix { inherit version src; };
in
stdenv.mkDerivation {
  pname = "jshelter";
  inherit version src;

  nativeBuildInputs = [ doxygen graphviz nodejs zip jshelter-wasm ];

  # Fontconfig error: Cannot load default config file
  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  # we get submodules and CSV using FOD
  postPatch = ''
    patchShebangs fix_manifest.sh generate_fpd.sh nscl/include.sh
    substituteInPlace Makefile \
      --replace '$(COMMON_FILES) get_csv submodules' '$(COMMON_FILES)'

    substituteInPlace Makefile \
      --replace 'wasm: wasm/build/debug.wasm wasm/build/release.wasm' 'wasm:' \
      --replace 'cp wasm/build/release.wasm' 'cp ${jshelter-wasm}/lib/node_modules/wasm_farble/build/release.wasm' \
      --replace 'cp wasm/build/debug.wasm' 'cp ${jshelter-wasm}/lib/node_modules/wasm_farble/build/debug.wasm'
  '';

  preBuild = ''
    cp ${ipv4csv} common/ipv4.dat
    cp ${ipv6csv} common/ipv6.dat
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/jshelter
    cp jshelter_{chrome,firefox}.zip $out/share/jshelter/

    runHook postInstall
  '';

  meta = {
    description = "An anti-malware Web browser extension to mitigate potential threats from JavaScript, including fingerprinting, tracking, and data collection";
    homepage = "https://jshelter.org";
    license = with lib.licenses; [
      cc0
      cc-by-40
      fdl13Plus
      gpl3Plus
      mit
      mpl20
    ]; # + CC-BY-ND-4.0
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ getpsyched ];
  };
}
