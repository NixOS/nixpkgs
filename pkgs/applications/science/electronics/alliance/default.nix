{ lib, stdenv, fetchFromGitLab, xorgproto, motif, libX11, libXt, libXpm, bison
, flex, automake, autoconf, libtool
}:

stdenv.mkDerivation rec {
  pname = "alliance";
  version = "unstable-2021-09-15";

  src = fetchFromGitLab {
    domain = "gitlab.lip6.fr";
    owner = "vlsi-eda";
    repo = "alliance";
    rev = "5e83c92d0307cce9d599f7099fb0023f81d26d65";
    sha256 = "Vd3MTT4eKn4FMt0/F4fQUPcWq25kH0FpeGxQUOetKPY=";
  };

  prePatch = "cd alliance/src";

  nativeBuildInputs = [ libtool automake autoconf flex ];
  buildInputs = [ xorgproto motif libX11 libXt libXpm bison ];

  # Disable parallel build, errors:
  #  ./pat_decl_y.y:736:5: error: expected '=', ...
  enableParallelBuilding = false;

  ALLIANCE_TOP = placeholder "out";

  configureFlags = [
    "--prefix=${placeholder "out"}" "--enable-alc-shared"
  ];

  postPatch = ''
    # texlive for docs seems extreme
    substituteInPlace autostuff \
      --replace "$newdirs documentation" "$newdirs"

    substituteInPlace sea/src/DEF_grammar_lex.l --replace "ifndef FLEX_BETA" \
      "if (YY_FLEX_MAJOR_VERSION <= 2) && (YY_FLEX_MINOR_VERSION < 6)"

    ./autostuff
  '';

  postInstall = ''
    sed -i "s|ALLIANCE_TOP|$out|" distrib/*.desktop
    mkdir -p $out/share/applications
    cp -p distrib/*.desktop $out/share/applications/
    mkdir -p $out/icons/hicolor/48x48/apps/
    cp -p distrib/*.png $out/icons/hicolor/48x48/apps/
  '';

  meta = with lib; {
    description = "(deprecated) Complete set of free CAD tools and portable libraries for VLSI design";
    homepage = "http://coriolis.lip6.fr/";
    license = with licenses; gpl2Plus;
    maintainers = with maintainers; [ l-as ];
    platforms = with platforms; linux;
  };
}
