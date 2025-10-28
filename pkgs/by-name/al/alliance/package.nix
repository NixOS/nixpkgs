{
  lib,
  stdenv,
  fetchFromGitHub,
  xorgproto,
  motif,
  libX11,
  libXt,
  libXpm,
  bison,
  flex,
  automake,
  autoconf,
  libtool,
}:

stdenv.mkDerivation {
  pname = "alliance";
  version = "unstable-2025-02-24";

  src =
    let
      src = fetchFromGitHub {
        owner = "lip6";
        repo = "alliance";
        rev = "a8502d32df0a4ad1bd29ab784c4332319669ecd2";
        hash = "sha256-b2uaYZEzHMB3qCMRVANNnjTxr6OYb1Unswxjq5knYzM=";
      };
    in
    "${src}/alliance/src";

  nativeBuildInputs = [
    libtool
    automake
    autoconf
    flex
  ];
  buildInputs = [
    xorgproto
    motif
    libX11
    libXt
    libXpm
    bison
  ];

  configureFlags = [
    "--enable-alc-shared"
  ];

  # To avoid compiler error in LoadDataBase.c:366:27
  env.NIX_CFLAGS_COMPILE = "-Wno-incompatible-pointer-types";

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
    maintainers = [ ];
    platforms = with platforms; linux;
  };
}
