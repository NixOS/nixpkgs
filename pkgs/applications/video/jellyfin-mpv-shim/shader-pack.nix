{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "jellyfin-mpv-shim-shader-pack";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = "default-shader-pack";
    rev = "v${version}";
    sha256 = "04y8gvjy4v3773b1kyan4dxqcf86b56x7v33m2k246jbn0rl2pgr";
  };

  installPhase = ''
    mkdir -p $out
    cp -a . $out
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/iwalton3/default-shader-pack";
    description = "Preconfigured set of MPV shaders and configurations for MPV Shim media clients";
    license = with licenses; [ mit lgpl3Plus unlicense ];
    maintainers = with maintainers; [ jojosch ];
  };
}
