{
  stdenv,
  fetchFromGitea,
  lib,
  pkgs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sgnotes";
  version = "1.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ItsZariep";
    repo = "SGNotes";
    rev = finalAttrs.version;
    hash = "sha256-WpQOtjPICbVB3TLSKXLa/7uw8rsWhBz4pljhTxWxLkw=";
  };

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [
    pkgs.gtk3
    pkgs.gtksourceview4
  ];

  buildPhase = ''
    cd src
    ${pkgs.gnumake}/bin/make SHELL=${pkgs.bash}/bin/bash
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp sgnotes $out/bin
  '';

  meta = {
    description = "Simple GTK Notes App";
    homepage = "https://codeberg.org/ItsZariep/SGNotes";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ reylak ];
    mainProgram = "sgnotes";
  };
})
