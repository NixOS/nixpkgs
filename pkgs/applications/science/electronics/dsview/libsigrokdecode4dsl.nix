{ stdenv, pkgconfig, autoreconfHook,
glib, check, python3, dsview
}:

stdenv.mkDerivation rec {
  inherit (dsview) version src;

  name = "libsigrokdecode4dsl-${version}";

  postUnpack = ''
    export sourceRoot=$sourceRoot/libsigrokdecode4DSL
  '';

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  buildInputs = [
    python3 glib check
  ];

  meta = with stdenv.lib; {
    description = "A fork of the sigrokdecode library for usage with DSView";
    homepage = https://www.dreamsourcelab.com/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bachp ];
  };
}
