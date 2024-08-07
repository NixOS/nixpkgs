{
  stdenv, lib, pkg-config
,  fetchurl
,  cmake
,  libjack2
,  alsa-lib
,  libsndfile
,  liblo
,  lv2
,  qt6
,  xorg
}:

stdenv.mkDerivation rec {
  pname = "drumkv1";
  version = "1.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/drumkv1/${pname}-${version}.tar.gz";
    sha256 = "sha256-vi//84boqaVxC/KCg+HF76vB4Opch02LU4RtbVaxaX4=";
  };

  buildInputs = [
    libjack2
    alsa-lib
    libsndfile
    liblo
    lv2
    qt6.full
    xorg.libX11
    qt6.qtbase
    qt6.qtwayland
  ];

  nativeBuildInputs = [ pkg-config cmake qt6.wrapQtAppsHook ];

  cmakeFlags = [ "-DCONFIG_LV2_PORT_CHANGE_REQUEST=false" ]; # disable experimental feature "LV2 port change request"

  installPhase = let
  lv2Dir = "$out/lib/lv2/drumkv1.lv2";
  in ''
    runHook preInstall
    make install
    mkdir -p ${lv2Dir}
    # -- some workaround, since it always wants to install to /$out/$out -- #
    mv $out/${lv2Dir} $out/lib/lv2/
    runHook postInstall
    rm -r $out/nix
  '';

  meta = with lib; {
    description = "Old-school drum-kit sampler synthesizer with stereo fx";
    mainProgram = "drumkv1_jack";
    homepage = "http://drumkv1.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
