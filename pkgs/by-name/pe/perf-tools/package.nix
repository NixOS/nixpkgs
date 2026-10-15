{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation {
  pname = "perf-tools";
  version = "unstable-2017-12-19";

  src = fetchFromGitHub {
    owner = "brendangregg";
    repo = "perf-tools";
    rev = "98d42a2a1493d2d1c651a5c396e015d4f082eb20";
    hash = "sha256-bKTl/iVhEI4qyjlEPZ1BMjuNnqjC3N0UNnmSdpPWFic=";
  };

  buildInputs = [ perl ];

  patchPhase = ''
    for i in execsnoop iolatency iosnoop kernel/funcslower killsnoop opensnoop; do
      substituteInPlace $i \
        --replace /usr/bin/gawk "$(type -p gawk)" \
        --replace /usr/bin/mawk /no-such-path \
        --replace /usr/bin/getconf "$(type -p getconf)" \
        --replace awk=awk "awk=$(type -p gawk)"
    done

    rm -rf examples deprecated
  '';

  installPhase = ''
    d=$out/libexec/perf-tools
    mkdir -p $d $out/share
    cp -prvd . $d/
    ln -s $d/bin $out/bin
    mv $d/man $out/share/
  '';

  meta = {
    platforms = lib.platforms.linux;
    homepage = "https://github.com/brendangregg/perf-tools";
    description = "Performance analysis tools based on Linux perf_events (aka perf) and ftrace";
    maintainers = [ ];
    license = lib.licenses.gpl2Plus;
  };
}
