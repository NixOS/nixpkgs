{ lib, stdenv
, fetchurl
, pkg-config
, dconf
, telepathy-glib
, python3
, libxslt
, makeWrapper
, autoreconfHook
, gtk-doc
}:

stdenv.mkDerivation rec {
  pname = "telepathy-mission-control";
  version = "5.16.6";

  outputs = [ "out" "lib" "dev" ];

  src = fetchurl {
    url = "https://telepathy.freedesktop.org/releases/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0ibs575pfr0wmhfcw6ln6iz7gw2y45l3bah11rksf6g9jlwsxy1d";
  };

  buildInputs = [
    python3
  ]; # ToDo: optional stuff missing

  nativeBuildInputs = [
    pkg-config
    libxslt
    makeWrapper
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    autoreconfHook
    gtk-doc
  ];

  propagatedBuildInputs = [
    telepathy-glib
  ];

  doCheck = true;

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram "$lib/libexec/mission-control-5" \
      --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with lib; {
    description = "Account manager and channel dispatcher for the Telepathy framework";
    homepage = "https://telepathy.freedesktop.org/components/telepathy-mission-control/";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
