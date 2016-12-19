{ stdenv, fetchFromGitHub, cmake, lua, pkgconfig, rsync,
  asciidoc, libxml2, docbook_xml_dtd_45, docbook_xml_xslt, libxslt }:

stdenv.mkDerivation rec {
  name = "lsyncd-${version}";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "axkibe";
    repo = "lsyncd";
    rev = "release-${version}";
    sha256 = "1cab96h4qfyapk7lb682j1d8k0hpv7h9pl41vdgc0vr4bq4c3ij2";
  };

  patchPhase = ''
    substituteInPlace default-rsync.lua \
      --replace "/usr/bin/rsync" "${rsync}/bin/rsync"
  '';

  dontUseCmakeBuildDir = true;

  buildInputs = [
    rsync
    cmake lua pkgconfig
    asciidoc libxml2 docbook_xml_dtd_45 docbook_xml_xslt libxslt
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/axkibe/lsyncd;
    description = "A utility that synchronizes local directories with remote targets";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bobvanderlinden ];
  };
}
