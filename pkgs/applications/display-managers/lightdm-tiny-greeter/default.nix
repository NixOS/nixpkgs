{ stdenv, linkFarm, lightdm-tiny-greeter, fetchFromGitHub
, pkgconfig, lightdm, gtk3, glib, wrapGAppsHook, conf ? "" }:

stdenv.mkDerivation rec {
  pname = "lightdm-tiny-greeter";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "off-world";
    repo = "lightdm-tiny-greeter";
    rev = version;
    sha256 = "08azpj7b5qgac9bgi1xvd6qy6x2nb7iapa0v40ggr3d1fabyhrg6";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [ lightdm gtk3 glib ];

  postUnpack = if conf != "" then ''
    cp ${builtins.toFile "config.h" conf} source/config.h
  '' else "";

  buildPhase = ''
    mkdir -p $out/bin $out/share/xgreeters
    make ${pname}
    mv ${pname} $out/bin/.
    mv lightdm-tiny-greeter.desktop $out/share/xgreeters
  '';

  installPhase = ''
    substituteInPlace "$out/share/xgreeters/lightdm-tiny-greeter.desktop" \
      --replace "Exec=lightdm-tiny-greeter" "Exec=$out/bin/lightdm-tiny-greeter"
  '';

  passthru.xgreeters = linkFarm "lightdm-tiny-greeter-xgreeters" [{
    path = "${lightdm-tiny-greeter}/share/xgreeters/lightdm-tiny-greeter.desktop";
    name = "lightdm-tiny-greeter.desktop";
  }];

  meta = with stdenv.lib; {
    description = "A tiny multi user lightdm greeter";
    homepage = https://github.com/off-world/lightdm-tiny-greeter;
    license = licenses.bsd3;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };
}
