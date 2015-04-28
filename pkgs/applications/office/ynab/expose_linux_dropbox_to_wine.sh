#!/bin/sh

# Assume a default wine bottle location. If `WINEPREFIX`
# environment variable is set, this will define the
# location of our bottle.
WINE_BOTTLE=$HOME/.wine
[ -z ${WINEPREFIX+x} ] || WINE_BOTTLE=$WINEPREFIX

# Make sure the wine bottle gets initialized before we lauch the program so
# that we have the oppotunity to perform our fix.
[ -d $WINE_BOTTLE ] || (command -v wineboot > /dev/null && wineboot -i) || \
  { echo "ERROR! Wine bottle does not exists and *wineboot* command is unavailable."; exit 1; }

#
# Implement in a more robust way the trick described at:
# <http://forum.youneedabudget.com/discussion/16409/how-to-run-ynab-4-in-linux-using-wine>.
#
[ -e $HOME/.dropbox/host.db ] || \
  { echo "INFO: User \"$USER\" does not have any dropbox setup. Cloud sync won't work."; exit 0; }


DROPBOX_APPDATA=$WINE_BOTTLE/dosdevices/c:/users/$USER/Application\ Data/Dropbox

echo "Patching \"$DROPBOX_APPDATA\" so that it maps to our linux dropbox folder..."
mkdir -p "$DROPBOX_APPDATA"

# - First line is all '0's. Propagate it as was to the target `Host.db`.
cat $HOME/.dropbox/host.db | head -n1 > "$DROPBOX_APPDATA/Host.db"

# - Take the location of the dropbox folder stored in base64 from second line of 
#   `$HOME/.dropbox/host.db`
# - Transcode it to its normal ascii / utf8 form (e.g.: `/home/myuser/Dropbox`)
# - Transform this path so that it can be understood and reach from the wine machine
#   perspective (e.g.: `Z:\home\myuser\Dropbox`)
# - Trancode it back to base64 and store it to 
#   `/home/myuser/.wine/dosdevices/c:/users/rgauthier/Application Data/Dropbox/Host.db`
#   which is where *ynab* will look for the location of the dropbox folder.
cat $HOME/.dropbox/host.db | tail -n1 | base64 -d | \
  sed s?^/?Z\:/?g | tr '/' '\\' | base64 | \
  tr -d '\n' >> "$DROPBOX_APPDATA/Host.db"
