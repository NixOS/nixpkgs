Description: Disable plugin dialog. It uses a totally non-authenticated and non-trusted way of installing arbitrary code.
Author: Martin Pitt <mpitt@debian.org>
Bug-Debian: http://bugs.debian.org/640026

Index: calibre-0.8.29+dfsg/src/calibre/gui2/actions/preferences.py
===================================================================
--- calibre-0.8.29+dfsg.orig/src/calibre/gui2/actions/preferences.py	2011-12-16 05:49:14.000000000 +0100
+++ calibre-0.8.29+dfsg/src/calibre/gui2/actions/preferences.py	2011-12-20 19:29:04.798468930 +0100
@@ -28,8 +28,6 @@
             pm.addAction(QIcon(I('config.png')), _('Preferences'), self.do_config)
         cm('welcome wizard', _('Run welcome wizard'),
                 icon='wizard.png', triggered=self.gui.run_wizard)
-        cm('plugin updater', _('Get plugins to enhance calibre'),
-                icon='plugins/plugin_updater.png', triggered=self.get_plugins)
         if not DEBUG:
             pm.addSeparator()
             cm('restart', _('Restart in debug mode'), icon='debug.png',
