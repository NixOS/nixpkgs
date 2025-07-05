{
  lib,
  stdenv,
  fetchurl,
  libtool,
  pkg-config,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ace";
  version = "8.0.4";

  src = fetchurl {
    url = "https://download.dre.vanderbilt.edu/previous_versions/ACE-src-${finalAttrs.version}.tar.bz2";
    hash = "sha256-OkNYxVuZCA8Nxpjv+Nsz/0r/JalhrycTXqxSlIr7dZU=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    libtool
  ];
  buildInputs = [ perl ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=format-security"
  ];

  postPatch = ''
    patchShebangs ./MPC/prj_install.pl
    patchShebangs ./bin/mwc.pl
  '';

  # ACE.mwc: Built a select subset of components in the ACE release
  preConfigure = ''
    export INSTALL_PREFIX=$out
    export ACE_ROOT=$(pwd)
    export LD_LIBRARY_PATH="$ACE_ROOT/ace:$ACE_ROOT/lib"
    echo '#include "ace/config-linux.h"' > ace/config.h
    echo 'include $(ACE_ROOT)/include/makeinclude/platform_linux.GNU'\
    > include/makeinclude/platform_macros.GNU
    cat <<EOF > "$ACE_ROOT/ACE.mwc"
    workspace {
        exclude {
            apps/gperf/tests
            apps/Gateway
            apps/JAWS
            apps/JAWS2
            apps/JAWS3
            apps/drwho
            apps/mkcsregdb
            apps/soreduce

            ACEXML/tests
            Kokyu/tests
            ACEXML/examples
            netsvcs/clients
            protocols/examples

            ASNMP
            examples
            performance-tests
            websvcs
        }
    }
    EOF
    ./bin/mwc.pl -type gnuace ACE.mwc
  '';

  meta = {
    homepage = "https://www.dre.vanderbilt.edu/~schmidt/ACE.html";
    description = "ADAPTIVE Communication Environment";
    mainProgram = "ace_gperf";
    license = lib.licenses.doc;
    maintainers = with lib.maintainers; [ nico202 ];
    platforms = lib.platforms.linux;
  };
})
