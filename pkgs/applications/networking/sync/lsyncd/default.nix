{ stdenv, fetchFromGitHub, cmake, lua, pkgconfig, rsync,
  asciidoc, libxml2, docbook_xml_dtd_45, docbook_xml_xslt, libxslt }:

stdenv.mkDerivation rec {
  name = "lsyncd-${version}";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "axkibe";
    repo = "lsyncd";
    rev = "release-${version}";
    sha256 = "1q2ixp52r96ckghgmxdbms6xrq8dbziimp8gmgzqfq4lk1v1w80y";
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
