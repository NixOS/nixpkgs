pref("toolkit.defaultChromeURI", "chrome://nixos-gui/content/myviewer.xul");
pref("general.useragent.extra.myviewer", "NixOS gui/0.0");

/* debugging prefs */
pref("browser.dom.window.dump.enabled", true);  // enable output to stderr
pref("javascript.options.showInConsole", true); // show javascript errors from chrome: files in the jsconsole
pref("javascript.options.strict", true);        // show javascript strict warnings in the jsconsole

/* disable xul cache so that modifications to chrome: files apply without restarting xulrunner */
pref("nglayout.debug.disable_xul_cache", true); 
pref("nglayout.debug.disable_xul_fastload", true);
