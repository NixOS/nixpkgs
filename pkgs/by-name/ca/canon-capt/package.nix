{
  autoconf,
  automake,
  cups,
  fetchFromGitHub,
  lib,
  stdenv,
}:

let
  version = "2016-06-14";
in
stdenv.mkDerivation {
  pname = "canon-capt";
  inherit version;

  src = fetchFromGitHub {
    owner = "ValdikSS";
    repo = "captdriver";
    rev = "892f320c019974a5b737e000fcc2c8582264a131";
    hash = "sha256-CcLGIhJ8HU0eu2MdA8ssT1EQsNLQicpItmyoClJHW3g=";
  };

  nativeBuildInputs = [
    autoconf
    automake
  ];

  buildInputs = [ cups ];

  # Fix for 'ppdc: Unable to find include file "<font.defs>"', which blocks '*.ppd' generation.
  # Issue occurs in hermetic sandbox; this workaround is the current solution.
  # Source: https://github.com/NixOS/nixpkgs/blob/9997402000a82eda4327fde36291234118c7515e/pkgs/misc/drivers/hplip/default.nix#L160
  env.CUPS_DATADIR = "${cups}/share/cups";

  configurePhase = ''
    runHook preConfigure
    aclocal
    autoconf
    automake --add-missing
    ./configure --prefix=$out/usr
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    make
    make ppd
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/cups/filter
    install -D -m 755 ./src/rastertocapt $out/lib/cups/filter/rastertocapt

    mkdir -p $out/share/cups/model/canon
    install -D -m 644 ./ppd/CanonLBP-2900-3000.ppd $out/share/cups/model/canon/CanonLBP-2900-3000.ppd
    install -D -m 644 ./ppd/CanonLBP-3010-3018-3050.ppd $out/share/cups/model/canon/CanonLBP-3010-3018-3050.ppd
    install -D -m 644 ./ppd/CanonLBP-6000.ppd $out/share/cups/model/canon/CanonLBP-6000.ppd

    runHook postInstall
  '';

  meta = {
    description = "Community-driven driver for Canon CAPT-based printers";
    homepage = "https://github.com/mounaiban/captdriver";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      cryptoluks
      theeasternfurry
    ];
    platforms = lib.platforms.linux;
  };
}
