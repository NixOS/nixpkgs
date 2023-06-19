{ lib
, stdenv
, autoconf
, automake
, autoreconfHook
, cg3
, fetchFromGitHub
, hfst
, hfst-ospell
, icu
, libtool
, libvoikko
, pkg-config
, python3
, python3Packages
, zip
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "omorfi";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "flammie";
    repo = "omorfi";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-UoqdwNWCNOPX6u1YBlnXUcB/fmcvcy/HXbYciVrMBOY=";
  };

  # Fix for omorfi-hyphenate.sh file not found error
  postInstall = ''
    ln -s $out/share/omorfi/{omorfi.hyphenate-rules.hfst,omorfi.hyphenate.hfst}
  '';

  nativeBuildInputs = [
    autoreconfHook
    cg3
    makeWrapper
    pkg-config
    python3
    zip
    python3.pkgs.wrapPython
  ];

>>>>>>> 2ea2d99a91e (hfst changes):pkgs/development/libraries/omorfi/default.nix
  buildInputs = [
    hfst
    hfst-ospell
    python3Packages.hfst-python
    icu
  ];
  nativeBuildInputs = [
    autoconf
    automake
    autoreconfHook
    cg3
    libtool
    pkg-config
    python3
    libvoikko
    zip
  ];
  propagatedBuildInputs = [
    hfst
    python3Packages.hfst
    icu
  ];

  # Enable all features
  configureFlags = [
    "--enable-labeled-segments"
    "--enable-lemmatiser"
    "--enable-segmenter"
    "--enable-hyphenator"
  ];

  # Fix for omorfi-hyphenate.sh file not found error
  postInstall = ''
    mv $out/share/omorfi/omorfi.hyphenate-rules.hfst $out/share/omorfi/omorfi.hyphenate.hfst
  '';

  src = fetchFromGitHub {
    owner = "flammie";
    repo = "omorfi";
    rev = "refs/tags/v${version}";
    hash = "sha256-UoqdwNWCNOPX6u1YBlnXUcB/fmcvcy/HXbYciVrMBOY=";
  };

  meta = with lib; {
    description = "Analysis for Finnish text";
    homepage = "https://github.com/flammie/omorfi";
    license = licenses.gpl3;
    maintainers = with maintainers; [ lurkki ];
  };
})
