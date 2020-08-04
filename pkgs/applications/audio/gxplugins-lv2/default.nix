{ stdenv, fetchFromGitHub, xorg, xorgproto, cairo, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "GxPlugins.lv2";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = pname;
    rev = "v${version}";
    sha256 = "11iv7bwvvspm74pisqvcpsxpg9xi6b08hq4i8q67mri4mvy9hmal";
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
    homepage = "https://github.com/brummer10/GxPlugins.lv2";
    description = "A set of extra lv2 plugins from the guitarix project";
    maintainers = [ maintainers.magnetophon ];
    license = licenses.gpl3;
  };
}
