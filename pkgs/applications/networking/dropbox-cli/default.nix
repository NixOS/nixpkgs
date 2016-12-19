{ stdenv, pkgconfig, fetchurl, python, dropbox }:
let
  version = "2015.10.28";
  dropboxd = "${dropbox}/bin/dropbox";
in
stdenv.mkDerivation {
  name = "dropbox-cli-${version}";

  src = fetchurl {
    url = "https://linux.dropbox.com/packages/nautilus-dropbox-${version}.tar.bz2";
    sha256 = "1ai6vi5227z2ryxl403693xi63b42ylyfmzh8hbv4shp69zszm9c";
  };

  buildInputs = [ pkgconfig python ];

  phases = "unpackPhase installPhase";

  installPhase = ''
    mkdir -p "$out/bin/" "$out/share/applications"
    cp data/dropbox.desktop "$out/share/applications"
    substitute "dropbox.in" "$out/bin/dropbox" \
      --replace '@PACKAGE_VERSION@' ${version} \
      --replace '@DESKTOP_FILE_DIR@' "$out/share/applications" \
      --replace '@IMAGEDATA16@' '"too-lazy-to-fix"' \
      --replace '@IMAGEDATA64@' '"too-lazy-to-fix"'
    sed -i 's:db_path = .*:db_path = "${dropboxd}":' $out/bin/dropbox
    chmod +x "$out/bin/"*
    patchShebangs "$out/bin"
  '';

  meta = {
    homepage = http://dropbox.com;
    description = "Command line client for the dropbox daemon";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    # NOTE: Dropbox itself only works on linux, so this is ok.
    platforms = stdenv.lib.platforms.linux;
  };
}
