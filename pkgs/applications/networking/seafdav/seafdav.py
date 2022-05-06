# This is a WSGI application that can be run via GUnicorn.
#
# It is unclear why Seafile does not provide this script with seafdav,
# when a similar script does exist for seahub. The existing server_cli
# script is not as flexible since it is a Python script that launches
# GUnicorn (or other WSGI servers) instead of being a consumable
# WSGI application. For example, server_cli isn't able to bind to a
# unix socket.

from wsgidav.default_conf import DEFAULT_CONFIG
from wsgidav.wsgidav_app import WsgiDAVApp
from wsgidav.server.server_cli import _loadSeafileSettings

import copy, logging

config = copy.deepcopy(DEFAULT_CONFIG)

logging.info("share_name = %s", config.get("share_name"))

# gets us data from seafdav.conf,
# and sets up the general Seafile configuration.
_loadSeafileSettings(config)

application = WsgiDAVApp(config)
