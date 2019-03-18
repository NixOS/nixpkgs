{ appimageTools, fetchurl, lib }:

let
  pname = "MineTime";
  version = "1.4.11";
in
appimageTools.wrapType2 rec {
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/marcoancona/MineTime/releases/download/v${version}/${name}-x86_64.AppImage";
    sha256 = "1kdwsfr28bmnqfz4q80d7n3fqxlk70r01kx9hjz89v11slkp3pf7";
  };

  extraPkgs = p: p.atomEnv.packages;

  # Ideally inherit this, but it needs to be set or the app fails to launch.
  profile = ''
    export LC_ALL=C.UTF8
  '';

  meta = with lib; {
    description = "Modern, intuitive and smart calendar application";
    homepage = https://minetime.ai;
    license = licenses.unfree;
    # Should be cross-platform, but for now we just grab the appimage
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ dtzWill ];
  };
}
