{ stdenv, pkgconfig, fetchurl, python, dropbox }:
let
  version = "2.10.0";
  dropboxd = "${dropbox}/bin/dropbox";
in
stdenv.mkDerivation {
  name = "dropbox-cli-${version}";

  src = fetchurl {
    url = "https://linux.dropbox.com/packages/nautilus-dropbox-${version}.tar.bz2";
    sha256 = "0f765rpp357vy7zvn1jq6q48d10fi4v13yb7vv3qx3az3f3472lg";
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
