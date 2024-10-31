{
  autoconf,
  automake,
  cups,
  fetchFromGitHub,
  lib,
  stdenv,
}:

let
  version = "0.1.4.2-GxB";
in
stdenv.mkDerivation {
  pname = "canon-capt";
  inherit version;

  src = fetchFromGitHub {
    owner = "mounaiban";
    repo = "captdriver";
    rev = "8ecc3cde1ae9a20dcb015994bb0fea0dbefa2b83";
    hash = "sha256-FslofWZNmF7G9+lmw1JehRBYZIAXcg6Dmv9xJ/c4Evo=";
  };

  nativeBuildInputs = [
    autoconf
    automake
  ];

  buildInputs = [ cups ];

  # Fix for 'ppdc: Unable to find include file "<font.defs>"', which blocks '*.ppd' generation.
  # Issue occurs in hermetic sandbox; this workaround is the current solution.
  # Source: https://github.com/NixOS/nixpkgs/blob/9997402000a82eda4327fde36291234118c7515e/pkgs/misc/drivers/hplip/default.nix#L160
  CUPS_DATADIR = "${cups}/share/cups";

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

    runHook postInstall
  '';

  meta = with lib; {
    description = "Community-driven driver for Canon CAPT-based printers";
    homepage = "https://github.com/mounaiban/captdriver";
    license = licenses.gpl3;
    maintainers = with maintainers; [ cryptoluks ];
    platforms = platforms.linux;
  };
}
