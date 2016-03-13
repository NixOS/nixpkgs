{ stdenv, fetchurl, fetchpatch, bash, firefox, perl, unzipNLS, xorg }:

let

  xpi = fetchurl {
    url = "https://download.zotero.org/extension/zotero-${version}.xpi";
    sha256 = "02h2ja08v8as4fawj683rh5rmxsjf5d0qmvqa77i176nm20y5s7s";
  };

  firefox' = stdenv.lib.overrideDerivation (firefox) (attrs: {
    patches = [ (fetchpatch {
      url = "https://hg.mozilla.org/releases/mozilla-beta/raw-rev/0558da46f20c";
      sha256 = "08ibp7hny78x8ywfvrh56z90kf8fjpf04mibdlrwkw4f1vgm3fc3";
      name = "fix-external-xpi-loader";
    }) ];
  });

  version = "4.0.28";

in
stdenv.mkDerivation {
  name = "zotero-${version}";
  inherit version;

  src = fetchurl {
    url = "https://github.com/zotero/zotero-standalone-build/archive/4.0.28.8.tar.gz";
    sha256 = "ab1fd5dde9bd2a6b6d31cc9a53183a04de3698f1273a943ef31ecc4c42808a68";
  };

  nativeBuildInputs = [ perl unzipNLS ];

  inherit bash;

  firefox = firefox';

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
