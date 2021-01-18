{ lib, stdenv, fetchurl, pkg-config, libmtp, libid3tag, flac, libvorbis, gtk3
, gsettings-desktop-schemas, wrapGAppsHook
}:

let version = "1.3.11"; in

stdenv.mkDerivation {
  pname = "gmtp";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/gmtp/gMTP-${version}/gmtp-${version}.tar.gz";
    sha256 = "04q6byyq002fhzkc2rkkahwh5b6272xakaj4m3vwm8la8jf0r0ss";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];
  buildInputs = [ libmtp libid3tag flac libvorbis gtk3 gsettings-desktop-schemas ];

  enableParallelBuilding = true;

  preFixup = ''
    gappsWrapperArgs+=(--add-flags "--datapath \"$out/share\"");
  '';

  meta = {
    description = "A simple MP3 and Media player client for UNIX and UNIX like systems";
    homepage = "https://gmtp.sourceforge.io";
    platforms = lib.platforms.linux;
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
