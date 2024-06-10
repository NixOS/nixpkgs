{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, gst_all_1
, libviperfx
, makeWrapper
}:
let
  gstPluginPath = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with gst_all_1; [ gstreamer gst-plugins-viperfx gst-plugins-base gst-plugins-good ]);
in
stdenv.mkDerivation rec {
  pname = "viper4linux";
  version = "unstable-2022-03-13";

  src = fetchFromGitHub {
    owner = "Audio4Linux";
    repo = "Viper4Linux";
    rev = "5da25644824f88cf0db24378d2c84770ba4f6816";
    sha256 = "sha256-CJNVr/1ehJzX45mxunXcRAypBBGEBdswOzAVG2H+ayg=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-viperfx
    libviperfx
  ];

  dontBuild = true;

  postPatch = ''
    substituteInPlace viper --replace "/etc/viper4linux" "$out/etc/viper4linux"
  '';

  installPhase = ''
    runHook preInstall
    install -D viper -t $out/bin
    mkdir -p $out/etc/viper4linux
    cp -r viper4linux/* $out/etc/viper4linux
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/viper" \
      --prefix PATH : $out/bin:${lib.makeBinPath [ gst_all_1.gstreamer ]} \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ${gstPluginPath} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libviperfx ]}
  '';

  meta = with lib; {
    description = "Adaptive Digital Sound Processor";
    homepage = "https://github.com/Audio4Linux/Viper4Linux";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ rewine ];
  };
}
