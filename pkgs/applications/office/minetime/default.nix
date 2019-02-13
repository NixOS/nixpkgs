{ appimageTools, fetchurl, lib }:

let
  pname = "MineTime";
  version = "1.4.10";
in
appimageTools.wrapType2 rec {
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/marcoancona/MineTime/releases/download/v${version}/${name}-x86_64.AppImage";
    sha256 = "11w1v9vlg51masxgigraqp5547dl02jrrwhzz5gcckv4l9y8rlyw";
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
