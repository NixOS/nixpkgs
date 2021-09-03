{ lib, stdenv, fetchFromGitHub, xorg, xorgproto, cairo, lv2, pkg-config }:

stdenv.mkDerivation rec {
  pname = "GxPlugins.lv2";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = pname;
    rev = "v${version}";
    sha256 = "02fksl8wr443ygwgcd1c2zab8kp67a6ps12k71ysqx7szv4zq877";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    xorg.libX11 xorgproto cairo lv2
  ];

  installFlags = [ "INSTALL_DIR=$(out)/lib/lv2" ];

  configurePhase = ''
    for i in GxBoobTube GxValveCaster; do
      substituteInPlace $i.lv2/Makefile --replace "\$(shell which echo) -e" "echo -e"
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/brummer10/GxPlugins.lv2";
    description = "A set of extra lv2 plugins from the guitarix project";
    maintainers = [ maintainers.magnetophon ];
    license = licenses.gpl3Plus;
  };
}
