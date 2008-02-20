/* Ubuntu dependencies
build-essential libxcomposite-dev libpng12-dev libsm-dev libxrandr-dev libxdamage-dev libxinerama-dev libstartup-notification0-dev libgconf2-dev libgl1-mesa-dev libglu1-mesa-dev libmetacity-dev librsvg2-dev libdbus-1-dev libdbus-glib-1-dev libgnome-desktop-dev libgnome-window-settings-dev gitweb curl autoconf automake automake1.9 libtool intltool libxslt1-dev xsltproc libwnck-dev
*/
args: with args;
[
	libpng 
	GConf mesa metacity librsvg dbus.libs dbus_glib gnomedesktop git autoconf automake
	libtool libxslt libwnck intltool perl perlXMLParser compiz
]
