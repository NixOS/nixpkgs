{ stdenv, fetchFromGitHub, xorg, xorgproto, cairo, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "GxPlugins.lv2";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jqdqnkg7pg9plcbxy49p7gcs1aj6h0xf7y9gndmjmkw5yjn2940";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    xorg.libX11 xorgproto cairo lv2
  ];

  installFlags = [ "INSTALL_DIR=$(out)/lib/lv2" ];

  configurePhase = ''
    for i in GxBoobTube GxValveCaster; do
      substituteInPlace $i.lv2/Makefile --replace "\$(shell which echo) -e" "echo -e"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/brummer10/GxPlugins.lv2;
    description = "A set of extra lv2 plugins from the guitarix project";
    maintainers = [ maintainers.magnetophon ];
    license = licenses.gpl3;
  };
}
