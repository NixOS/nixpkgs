{ lib, stdenv
, fetchFromGitHub
, SDL2
, SDL2_ttf
, libpcap
, vde2
, pcre
}:

stdenv.mkDerivation rec {
  pname = "simh";
  version = "3.11-1";

  src = fetchFromGitHub {
    owner = "simh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-65+YfOWpVXPeT64TZcSaWJY+ODQ0q/pwF9jb8xGdpIs=";
  };

  buildInputs = [ SDL2 SDL2_ttf libpcap vde2 pcre ];

  dontConfigure = true;

  # Workaround to build against upstream gcc-10 and clang-11.
  # Can be removed when next release contains
  #    https://github.com/simh/simh/issues/794
  env.NIX_CFLAGS_COMPILE = toString [ "-fcommon" ];

  makeFlags = [ "GCC=${stdenv.cc.targetPrefix}cc" "CC_STD=-std=c99" "LDFLAGS=-lm" ];

  preInstall = ''
    install -d ${placeholder "out"}/bin
    install -d ${placeholder "out"}/share/simh
  '';

  installPhase = ''
    runHook preInstall
    for i in BIN/*; do
      install -D $i ${placeholder "out"}/bin
    done
    for i in VAX/*bin; do
      install -D $i ${placeholder "out"}/share/simh
    done
    runHook postInstall
  '';

  postInstall = ''
    (cd $out/bin; for i in *; do ln -s $i simh-$i; done)
  '';

  meta = with lib; {
    homepage = "http://simh.trailing-edge.com/";
    description = "A collection of simulators of historic hardware";
    longDescription = ''
      SimH (History Simulator) is a collection of simulators for historically
      significant or just plain interesting computer hardware and software from
      the past. The goal of the project is to create highly portable system
      simulators and to publish them as freeware on the Internet, with freely
      available copies of significant or representative software.
    '';
    license = with licenses; mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
# TODO: install documentation
