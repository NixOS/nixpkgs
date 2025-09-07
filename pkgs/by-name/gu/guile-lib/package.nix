{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  gettext,
  guile,
  pkg-config,
  texinfo,
}:

stdenv.mkDerivation rec {
  pname = "guile-lib";
  version = "0.2.8.1";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-E3TC2Dnmoz0ZDNHavZx/h3U/g4T1W4ZvPhQhVcIrSbE=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
  ];
  buildInputs = [
    guile
    texinfo
  ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace 'SITEDIR="$datadir/guile-lib"' 'SITEDIR=$datadir/guile/site/$GUILE_EFFECTIVE_VERSION' \
      --replace 'SITECCACHEDIR="$libdir/guile-lib/guile/$GUILE_EFFECTIVE_VERSION/site-ccache"' 'SITECCACHEDIR="$libdir/guile/$GUILE_EFFECTIVE_VERSION/site-ccache"'
  '';

  # error: possibly undefined macro: AC_LIB_LINKFLAGS_FROM_LIBS
  preAutoreconf = ''
    cp ${gettext}/share/gettext/m4/lib-{ld,link,prefix}.m4 m4
  '';

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  preCheck = ''
    # Make `libgcc_s.so' visible for `pthread_cancel'.
    export LD_LIBRARY_PATH=\
    "$(dirname $(echo ${lib.getLib stdenv.cc.cc}/lib*/libgcc_s.so))''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
  '';

  meta = with lib; {
    homepage = "https://www.nongnu.org/guile-lib/";
    description = "Collection of useful Guile Scheme modules";
    longDescription = ''
      guile-lib is intended as an accumulation place for pure-scheme Guile
      modules, allowing for people to cooperate integrating their generic Guile
      modules into a coherent library.  Think "a down-scaled, limited-scope CPAN
      for Guile".
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      vyp
      foo-dogsquared
    ];
    platforms = guile.meta.platforms;
  };
}
