{
  fetchzip,
  lib,
  stdenv,
  cmake,
  cups,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "epson-tm-t88vi";
  version = "3.0.0.0";

  src = fetchzip {
    url = "https://download3.ebz.epson.net/dsc/f/03/00/15/35/42/b1a708bb8b21d7a68ae7394287db440974b68a0e/tmx-cups-src-ImpactReceipt-${finalAttrs.version}_pck_e.zip";
    hash = "sha256-c6VpnNXYebkDkK9kcTZ/ILE8pD/qSWKCHYqkHV+WIkc=";
  };

  buildInputs = [ cups ];
  nativeBuildInputs = [ cmake ];

  unpackPhase = ''
    runHook preUnpack

    tar xf $src/tmx-cups-src-ThermalReceipt-${finalAttrs.version}.tar.gz --strip-components=1

    runHook postUnpack
  '';

  postPatch = ''
    substituteInPlace ./ppd/*.ppd --replace-fail "rastertotmtr" "$out/lib/cups/filter/rastertotmtr"

    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
  '';

  installPhase = ''
    runHook preInstall

    install -Ds ./rastertotmtr $out/lib/cups/filter/rastertotmtr
    install ../ppd/*.ppd -Dt $out/share/cups/model/EPSON

    runHook postInstall
  '';

  meta = {
    description = "EPSON TM Series T88VI Series Printer Driver for Linux";
    downloadPage = "https://epson.com/Support/Point-of-Sale/OmniLink-Printers/Epson-TM-T88VI-Series/s/SPT_C31CE94061?review-filter=Linux";
    homepage = "https://www.epson.com/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ allsimon ];
  };
})
