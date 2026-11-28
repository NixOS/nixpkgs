import logging
import sys

errors = []


class ErrorCollector(logging.Handler):
    def emit(self, record):
        if record.levelno >= logging.ERROR:
            errors.append(self.format(record))


logging.getLogger().addHandler(ErrorCollector())
logging.getLogger().setLevel(logging.ERROR)

from octoprint.plugin.core import PluginManager

manager = PluginManager(
    plugin_folders=[],
    plugin_bases=[object],
    plugin_entry_points="octoprint.plugin",
    logging_prefix="test.",
)
manager.reload_plugins()

if errors:
    print("One or more plugins failed to load:", file=sys.stderr)
    for error in errors:
        print(f"  {error}", file=sys.stderr)
    sys.exit(1)

print(f"{len(manager.plugins)} plugins loaded successfully: {sorted(manager.plugins)}")
