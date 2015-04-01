{ stdenv, fetchurl, bash, firefox, perl, unzipNLS, xlibs }:

let

  xpi = fetchurl {
    url = "https://download.zotero.org/extension/zotero-${version}.xpi";
    sha256 = "15wdbwnaxs748psjnxw40wld45npjjmvwx70c0jx2p63y6ks2gcx";
  };

  version = "4.0.26";

in
stdenv.mkDerivation {
  name = "zotero-${version}";
  inherit version;

  src = fetchurl {
    url = "https://github.com/zotero/zotero-standalone-build/archive/${version}.tar.gz";
    sha256 = "11gbislxkhfycnii05v6d8h9qdp5rk5xag7kdnsih67gicnn467g";
  };

  nativeBuildInputs = [ perl unzipNLS ];

  inherit bash firefox;

  phases = "unpackPhase installPhase fixupPhase";

  installPhase = ''
    mkdir -p "$out/libexec/zotero"
    unzip "${xpi}" -d "$out/libexec/zotero"

    BUILDID=`date +%Y%m%d`
    GECKO_VERSION="${firefox.passthru.version}"
    UPDATE_CHANNEL="default"

    # Copy branding
    cp -R assets/branding "$out/libexec/zotero/chrome/branding"

    # Adjust chrome.manifest
    echo "" >> "$out/libexec/zotero/chrome.manifest"
    cat assets/chrome.manifest >> "$out/libexec/zotero/chrome.manifest"

    # Copy updater.ini
    cp assets/updater.ini "$out/libexec/zotero"

    # Adjust connector pref
    perl -pi -e 's/pref\("extensions\.zotero\.httpServer\.enabled", false\);/pref("extensions.zotero.httpServer.enabled", true);/g' "$out/libexec/zotero/defaults/preferences/zotero.js"
    perl -pi -e 's/pref\("extensions\.zotero\.connector\.enabled", false\);/pref("extensions.zotero.connector.enabled", true);/g' "$out/libexec/zotero/defaults/preferences/zotero.js"

    # Copy icons
    cp -r assets/icons "$out/libexec/zotero/chrome/icons"

    # Copy application.ini and modify
    cp assets/application.ini "$out/libexec/zotero/application.ini"
    perl -pi -e "s/{{VERSION}}/$version/" "$out/libexec/zotero/application.ini"
    perl -pi -e "s/{{BUILDID}}/$BUILDID/" "$out/libexec/zotero/application.ini"
    perl -pi -e "s/^MaxVersion.*\$/MaxVersion=$GECKO_VERSION/" "$out/libexec/zotero/application.ini"

    # Copy prefs.js and modify
    cp assets/prefs.js "$out/libexec/zotero/defaults/preferences"
    perl -pi -e 's/pref\("app\.update\.channel", "[^"]*"\);/pref\("app\.update\.channel", "'"$UPDATE_CHANNEL"'");/' "$out/libexec/zotero/defaults/preferences/prefs.js"
    perl -pi -e 's/%GECKO_VERSION%/'"$GECKO_VERSION"'/g' "$out/libexec/zotero/defaults/preferences/prefs.js"

    # Add platform-specific standalone assets
    cp -R assets/unix "$out/libexec/zotero"

    mkdir -p "$out/bin"
    substituteAll "${./zotero.sh}" "$out/bin/zotero"
    chmod +x "$out/bin/zotero"
  '';

  doInstallCheck = true;
  installCheckPhase = "$out/bin/zotero --version";

  meta = with stdenv.lib; {
    homepage = "https://www.zotero.org";
    description = "Collect, organize, cite, and share your research sources";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ttuegel ];
  };
}
