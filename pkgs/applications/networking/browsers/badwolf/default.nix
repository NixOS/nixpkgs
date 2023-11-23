{ stdenv
, lib
, fetchurl
, pkg-config
, webkitgtk
, libxml2
, ninja
, ed
}:
stdenv.mkDerivation rec {
  pname = "badwolf";
  version = "1.3.0";

  src = fetchurl {
    url = "https://hacktivis.me/releases/${pname}-${version}.tar.gz";
    hash = "sha256-J238y6it38IFzrEEd2aOSytqSFPzRMhtXB41sccDRZ8=";
  };

  preConfigure = ''
    export PREFIX=$out
  '';

  dontAddPrefix = true;

  nativeBuildInputs = [ pkg-config ninja ed ];

  buildInputs = [ webkitgtk libxml2 ];

  meta = with lib; {
    description = "Minimalist and privacy-oriented WebKitGTK+ browser";
    homepage = "https://hacktivis.me/projects/badwolf";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ laalsaas chen ];
  };

}
