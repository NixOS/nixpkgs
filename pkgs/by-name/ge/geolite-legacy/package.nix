{
  lib,
  stdenv,
  fetchzip,
  zstd,
  writeShellApplication,
  common-updater-scripts,
  pcre2,
}:

stdenv.mkDerivation rec {
  pname = "geolite-legacy";
  version = "20240720";

  # We use Arch Linux package as a snapshot, because upstream database is updated in-place.
  geoip = fetchzip {
    url = "https://archive.archlinux.org/packages/g/geoip-database/geoip-database-${version}-1-any.pkg.tar.zst";
    hash = "sha256-9rPp1Lu6Q4+Cb4N4e/ezHacpLuUwbGQefEPuSrH8O6o=";
    nativeBuildInputs = [ zstd ];
    stripRoot = false;
  };

  extra = fetchzip {
    url = "https://archive.archlinux.org/packages/g/geoip-database-extra/geoip-database-extra-${version}-1-any.pkg.tar.zst";
    hash = "sha256-sb06yszstKalc+b9rSuStRuY3YRebAL1Q4jEJkbGiMI=";
    nativeBuildInputs = [ zstd ];
    stripRoot = false;
  };

  buildCommand = ''
    mkdir -p $out/share/GeoIP
    cp ${geoip}/usr/share/GeoIP/*.dat $out/share/GeoIP
    cp ${extra}/usr/share/GeoIP/*.dat $out/share/GeoIP
  '';

  passthru = {
    updateScript = lib.getExe (writeShellApplication {
      name = "update-geolite-legacy";
      runtimeInputs = [
        common-updater-scripts
        pcre2
      ];
      text = ''
        url=https://archive.archlinux.org/packages/g/geoip-database/

        version=$(list-directory-versions --pname geoip-database --url $url |
                  pcre2grep -o1 '^(\d{8})-1-any\.pkg\.tar\.zst$' |
                  sort -n |
                  tail -1)

        for key in geoip extra; do
            update-source-version "$UPDATE_NIX_ATTR_PATH" "$version" --source-key=$key --ignore-same-version
        done
      '';
    });
  };

  meta = {
    description = "GeoLite Legacy IP geolocation databases";
    homepage = "https://mailfud.org/geoip-legacy/";
    license = lib.licenses.cc-by-sa-40;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ fpletz ];
  };
}
