{ stdenv, buildGoPackage, fetchFromGitHub, fetchpatch }:

buildGoPackage rec {
  pname = "mqtt-bench";
  version = "0.3.0";
  rev = "v${version}";

  goPackagePath = "github.com/takanorig/mqtt-bench";

  src = fetchFromGitHub {
    inherit rev;
    owner = "takanorig";
    repo = "mqtt-bench";
    sha256 = "03b9ak2j303iwq6abd7j10f2cs2ianwnbflwmyx9g96i7zd74f5m";
  };

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/takanorig/mqtt-bench/pull/13.patch";
      name = "mqtt-paho-changes.patch";
      sha256 = "17c8ajrp5dmbsasj6njxrlhy0x08b65fignzm3yccqbhb4ijcvha";
    })
  ];

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Mosquitto benchmark tool";
    homepage = "https://github.com/takanorig/mqtt-bench";
    maintainers = with maintainers; [ disassembler ];
  };
}
