{ lib
, nixosTests
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, pam
, sqlite
, libxslt
, docbook5
, docbook_xsl
, docbook_xsl_ns
, coreutils
}:

stdenv.mkDerivation rec {
  pname = "pam_lastlog2";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = "lastlog2";
    rev = "v${version}";
    sha256 = "2qGRV5ihJAdg/pfKHSvR57iEAAw0r39FbTmS3w47kcs=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    libxslt
    docbook5
    docbook_xsl
    docbook_xsl_ns
  ];

  buildInputs = [
    pam
    sqlite
   ];

  mesonFlags = [
    "--prefix=${placeholder "out"}"
    "-Drootprefix=${placeholder "out"}"
    "-Dpamlibdir=${placeholder "out"}/lib/security"
    "-Dman=true"
  ];

  postInstall = ''
    substituteInPlace $out/lib/systemd/system/lastlog2-import.service \
      --replace /usr/bin/lastlog2 $out/bin/lastlog2 \
      --replace /usr/bin/mv ${coreutils}/bin/mv
  '';

  meta = with lib; {
    description = "Y2038 safe version of lastlog";
    homepage = "https://github.com/thkukuk/lastlog2";
    changelog = "https://github.com/thkukuk/lastlog2/releases/tag/v${version}";
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
