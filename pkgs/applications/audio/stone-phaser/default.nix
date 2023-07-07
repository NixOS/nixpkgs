{ lib, stdenv, fetchFromGitHub, xorg, cairo, lv2, libjack2, mesa, pkg-config }:

stdenv.mkDerivation rec {
  pname = "stone-phaser";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = pname;
    rev = "v${version}";
    sha256 = "180b32z8h9zi8p0q55r1dzxfckamnngm52zjypjjvvy7qdj3mfcd";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    xorg.libX11 cairo lv2 libjack2 mesa
  ];

  postPatch = ''
    patch -d dpf -p 1 -i "$src/resources/patch/DPF-bypass.patch"
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    homepage = "https://github.com/jpcima/stone-phaser";
    description = "A classic analog phaser effect, made with DPF and Faust";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.boost;
  };
}
