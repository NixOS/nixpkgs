{ lib, stdenv, pkg-config, autoreconfHook,
glib, check, python3, dsview
}:

stdenv.mkDerivation {
  inherit (dsview) version src;

  pname = "libsigrokdecode4dsl";

  postUnpack = ''
    export sourceRoot=$sourceRoot/libsigrokdecode4DSL
  '';

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [
    python3 glib check
  ];

  meta = with lib; {
    description = "A fork of the sigrokdecode library for usage with DSView";
    homepage = "https://www.dreamsourcelab.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bachp ];
  };
}
