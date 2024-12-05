{ lib
, stdenvNoCC
, fetchFromGitHub
, clickgen
, python3
, themeVariants ? []
, sizeVariants ? []
, platformVariants ? []
}:

let
  pname = "fuchsia-cursor";
in
lib.checkListOfEnum "${pname}: theme variants" [ "Fuchsia" "Fuchsia-Pop" "Fuchsia-Red" ] themeVariants
lib.checkListOfEnum "${pname}: size variants" [ "16" "24" "32" "48" ] sizeVariants
lib.checkListOfEnum "${pname}: platform variants" [ "x11" "windows" ] platformVariants

stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "fuchsia-cursor";
    rev = "v${version}";
    hash = "sha256-WnDtUsjRXT7bMppgwU5BIDqphP69DmPzQM/0qXES5tM=";
  };

  nativeBuildInputs = [
    clickgen
    python3.pkgs.attrs
  ];

  installPhase = ''
    runHook preInstall

    ${if themeVariants != [] then ''
    name= ctgen build.toml \
      ${lib.optionalString (themeVariants != []) "-d bitmaps/" + toString themeVariants + " -n " + toString themeVariants} \
      ${lib.optionalString (sizeVariants != []) "-s " + toString sizeVariants} \
      ${lib.optionalString (platformVariants != []) "-p " + toString platformVariants} \
      -o $out/share/icons
    '' else ''
    name= ctgen build.toml -d bitmaps/Fuchsia -n Fuchsia \
      ${lib.optionalString (sizeVariants != []) "-s " + toString sizeVariants} \
      ${lib.optionalString (platformVariants != []) "-p " + toString platformVariants} \
      -o $out/share/icons
    ''}

    runHook postInstall
  '';

  meta = with lib; {
    description = "First OpenSource port of FuchsiaOS's cursors for Linux and Windows";
    homepage = "https://github.com/ful1e5/fuchsia-cursor";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.all;
    license = licenses.gpl3Plus;
  };
}
