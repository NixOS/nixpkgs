{ lib, stdenv, fetchurl, pkg-config, libmtp, libid3tag, flac, libvorbis, gtk3
, gsettings-desktop-schemas, wrapGAppsHook3
}:

let version = "1.3.11"; in

stdenv.mkDerivation {
  pname = "gmtp";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/gmtp/gMTP-${version}/gmtp-${version}.tar.gz";
    sha256 = "04q6byyq002fhzkc2rkkahwh5b6272xakaj4m3vwm8la8jf0r0ss";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook3 ];
  buildInputs = [ libmtp libid3tag flac libvorbis gtk3 gsettings-desktop-schemas ];

  enableParallelBuilding = true;

  # Workaround build failure on -fno-common toolchains:
  #   ld: gmtp-preferences.o:src/main.h:72: multiple definition of
  #     `scrolledwindowMain'; gmtp-about.o:src/main.h:72: first defined here
  # TODO: can be removed when 1.4.0 is released.
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  preFixup = ''
    gappsWrapperArgs+=(--add-flags "--datapath $out/share");
  '';

  meta = {
    description = "A simple MP3 and Media player client for UNIX and UNIX like systems";
    mainProgram = "gmtp";
    homepage = "https://gmtp.sourceforge.io";
    platforms = lib.platforms.linux;
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
