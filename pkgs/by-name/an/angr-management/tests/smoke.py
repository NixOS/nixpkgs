import sys
from importlib.metadata import version

import angr
import angrmanagement
import binsync
import declib
import pyqodeng
import PySide6QtAds
import qtawesome
import qtconsole
import qtpy
from angrmanagement.logic import GlobalInfo
from angrmanagement.ui.main_window import MainWindow
from declib.api.type_parser import CTypeParser
from PySide6 import QtCore
from PySide6.QtWidgets import QApplication

expected_version = sys.argv[1]

assert version("angr") == expected_version
assert version("angr-management") == expected_version
assert angr.__version__ == angrmanagement.__version__ == expected_version
assert qtpy.API_NAME == "PySide6"
assert QtCore.qVersion()
assert PySide6QtAds.__file__
assert all(
    module.__file__ for module in (binsync, declib, pyqodeng, qtawesome, qtconsole)
)

# Validate compatibility with nixpkgs' pycparser 3.
parsed = CTypeParser().parse_type("unsigned long *")
assert parsed.is_ptr and parsed.type == "unsigned long"

app = QApplication([])
assert app.platformName() == "offscreen"

GlobalInfo.gui_thread = QtCore.QThread.currentThread()
window = MainWindow(app=app, show=False, use_daemon=False, use_mcp=False)
assert window.windowTitle() == "angr management"
assert window.workspace is not None
assert window.menuBar() is not None

window.show()
app.processEvents()
assert window.isVisible()
window.close()
app.processEvents()
assert not window.isVisible()
app.quit()

print("angr-management dependencies, PySide6/QtAds, declib, and MainWindow: OK")
