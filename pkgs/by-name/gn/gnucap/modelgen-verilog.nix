{
  lib,
  stdenv,
  fetchurl,
  gnucap,
}:

stdenv.mkDerivation rec {
  pname = "gnucap-modelgen-verilog";
  version = "20240130-dev";

  src = fetchurl {
    url = "https://git.savannah.gnu.org/cgit/gnucap/gnucap-modelgen-verilog.git/snapshot/${pname}-${version}.tar.gz";
    hash = "sha256-7w0eWUJKVRYFicQgDvKrJTkZ6fzgwxvcCKj78KrHj8E=";
  };

  propagatedBuildInputs = [ gnucap ];

  doCheck = true;

  preInstall = ''
    export GNUCAP_EXEC_PREFIX=$out
    export GNUCAP_DATA=$out/share/gnucap
    mkdir -p $out/include/gnucap
    export GNUCAP_INCLUDEDIR=$out/include/gnucap
    export GNUCAP_PKGLIBDIR=$out/lib/gnucap
  '';

  meta = with lib; {
    description = "gnucap modelgen to preprocess, parse and dump vams files";
    homepage = "http://www.gnucap.org/";
    changelog = "https://git.savannah.gnu.org/cgit/gnucap.git/plain/NEWS?h=v${version}";
    mainProgram = "gnucap-mg-vams";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.raboof ];
  };
}
