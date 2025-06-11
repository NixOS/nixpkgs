{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glib,
  gst_all_1,
  makeWrapper,
  pkg-config,
  python3,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  sqlite,
  zlib,
  runtimeShell,
}:

stdenv.mkDerivation {
  pname = "retrofe";
  version = "0.10.31";

  src = fetchFromGitHub {
    owner = "phulshof";
    repo = "RetroFE";
    rev = "2ddd65a76210d241031c4ac9268255f311df25d1";
    sha256 = "sha256-uBfECbU2Df/pPpEXXq62S7Ec0YU4lPIsZ8k5UmKD7xQ=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    python3
  ];

  buildInputs =
    [
      glib
      gst_all_1.gstreamer
      SDL2
      SDL2_image
      SDL2_mixer
      SDL2_ttf
      sqlite
      zlib
    ]
    ++ (with gst_all_1; [
      gst-libav
      gst-plugins-base
      gst-plugins-good
    ]);

  configurePhase = ''
    cmake RetroFE/Source -BRetroFE/Build -DCMAKE_BUILD_TYPE=Release \
      -DVERSION_MAJOR=0 -DVERSION_MINOR=0 -DVERSION_BUILD=0 \
  '';

  buildPhase = ''
    cmake --build RetroFE/Build
    python Scripts/Package.py --os=linux --build=full
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/retrofe
    cp -r Artifacts/linux/RetroFE $out/share/retrofe/example
    mv $out/share/retrofe/example/retrofe $out/bin/

    cat > $out/bin/retrofe-init << EOF
    #!${runtimeShell}

    echo "This will install retrofe's example files into this directory"
    echo "Example files location: $out/share/retrofe/example/"

    while true; do
        read -p "Do you want to proceed? [yn] " yn
        case \$yn in
            [Yy]* ) cp -r --no-preserve=all $out/share/retrofe/example/* .; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer with yes or no.";;
        esac
    done
    EOF

    chmod +x $out/bin/retrofe-init

    runHook postInstall
  '';

  # retrofe will look for config files in its install path ($out/bin).
  # When set it will use $RETROFE_PATH instead. Sadly this behaviour isn't
  # documented well. To make it behave more like as expected it's set to
  # $PWD by default here.
  postInstall = ''
    wrapProgram "$out/bin/retrofe" \
      --prefix GST_PLUGIN_PATH : "$GST_PLUGIN_SYSTEM_PATH_1_0" \
      --run 'export RETROFE_PATH=''${RETROFE_PATH:-$PWD}'
  '';

  meta = with lib; {
    description = "Frontend for arcade cabinets and media PCs";
    homepage = "http://retrofe.nl/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hrdinka ];
    platforms = with platforms; linux;
  };
}
