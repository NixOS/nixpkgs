{ stdenv, lib, runCommand, fetchFromGitLab, wrapFirefox, firefox-unwrapped }:

let
  pkg = fetchFromGitLab {
    owner = "postmarketOS";
    repo = "mobile-config-firefox";
    rev = "ff2f07873f4ebc6e220da0e9b9f04c69f451edda";
    sha256 = "sha256-8wRz8corz00+0qROMiOmZAddM4tjfmE91bx0+P8JNx4=";
  };
  userChrome = runCommand "userChrome.css" {} ''
    cat ${pkg}/src/userChrome/*.css > $out
  '';
  userContent = runCommand "userContent.css" {} ''
    cat ${pkg}/src/userContent/*.css > $out
  '';
in wrapFirefox firefox-unwrapped {
  # extraPolicies = (lib.importJSON "${pkg}/src/policies.json").policies;
  extraPoliciesFiles = [ "${pkg}/src/policies.json" ];
  extraPrefs = ''
    // Copyright 2022 Arnaud Ferraris, Oliver Smith
    // SPDX-License-Identifier: MPL-2.0

    // This is a Firefox autoconfig file:
    // https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig

    // Import custom userChrome.css on startup or new profile creation
    const {classes: Cc, interfaces: Ci, utils: Cu} = Components;
    Cu.import("resource://gre/modules/Services.jsm");
    Cu.import("resource://gre/modules/FileUtils.jsm");

    var updated = false;

    // Create <profile>/chrome/ directory if not already present
    var chromeDir = Services.dirsvc.get("ProfD", Ci.nsIFile);
    chromeDir.append("chrome");
    if (!chromeDir.exists()) {
        chromeDir.create(Ci.nsIFile.DIRECTORY_TYPE, FileUtils.PERMS_DIRECTORY);
    }

    // Create nsIFile objects for userChrome.css in <profile>/chrome/ and in /etc/
    var chromeFile = chromeDir.clone();
    chromeFile.append("userChrome.css");
    var defaultChrome = new FileUtils.File("${userChrome}");

    // No auto-upgrade. Should this be replaced with symlinking?
    // // Remove the existing userChrome.css if older than the installed one
    // if (chromeFile.exists() && defaultChrome.exists() &&
    //   chromeFile.lastModifiedTime < defaultChrome.lastModifiedTime) {
    //   chromeFile.remove(false);
    // }

    // Copy userChrome.css to <profile>/chrome/
    if (!chromeFile.exists()) {
      defaultChrome.copyTo(chromeDir, "userChrome.css");
      updated = true;
    }

    // Create nsIFile objects for userContent.css in <profile>/chrome/ and in /etc/
    var contentFile = chromeDir.clone();
    contentFile.append("userContent.css");
    var defaultContent = new FileUtils.File("${userContent}");

    // No auto-upgrade. Should this be replaced with symlinking?
    // // Remove the existing userContent.css if older than the installed one
    // if (contentFile.exists() && defaultContent.exists() &&
    //   contentFile.lastModifiedTime < defaultContent.lastModifiedTime) {
    //   contentFile.remove(false);
    // }

    // Copy userContent.css to <profile>/chrome/
    if (!contentFile.exists()) {
      defaultContent.copyTo(chromeDir, "userContent.css");
      updated = true;
    }

    // Restart Firefox immediately if one of the files got updated
    if (updated === true) {
        var appStartup = Cc["@mozilla.org/toolkit/app-startup;1"].getService(Ci.nsIAppStartup);
        appStartup.quit(Ci.nsIAppStartup.eForceQuit | Ci.nsIAppStartup.eRestart);
    }

    defaultPref('general.useragent.override', 'Mozilla/5.0 (Android 11; Mobile; rv:96.0) Gecko/96.0 Firefox/96.0');
    defaultPref('browser.urlbar.suggest.topsites', false);
    defaultPref('browser.urlbar.suggest.engines', false);
    defaultPref('browser.newtabpage.enabled', true);

    // Enable android-style pinch-to-zoom
    pref('dom.w3c.touch_events.enabled', true);
    pref('apz.allow_zooming', true);
    pref('apz.allow_double_tap_zooming', true);

    // Save vertical space by hiding the titlebar
    pref('browser.tabs.inTitlebar', 1);

    // Disable search suggestions
    pref('browser.search.suggest.enabled', false);

    // Empty new tab page: faster, less distractions
    pref('browser.newtabpage.enabled', false);

    // Allow UI customizations with userChrome.css and userContent.css
    pref('toolkit.legacyUserProfileCustomizations.stylesheets', true);

    // Select the entire URL with one click
    pref('browser.urlbar.clickSelectsAll', true);

    // Disable cosmetic animations, save CPU
    pref('toolkit.cosmeticAnimations.enabled', false);

    // Disable download animations, save CPU
    pref('browser.download.animateNotifications', false);
  '';
}
