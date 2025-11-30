import plistlib
import sys

plist_path = sys.argv[1]

# Load existing Info.plist
with open(plist_path, 'rb') as f:
    pl = plistlib.load(f)

# These document types are required to be considered a browser by System Preferences
document_types = [
    {
        'CFBundleTypeName': 'HTML Document',
        'CFBundleTypeRole': 'Viewer',
        'LSItemContentTypes': ['public.html', 'public.xhtml']
    }
]
# These URL schemes are required to be considered a browser by System Preferences
url_types = [
    {
        'CFBundleURLName': 'http(s) URLs',
        'CFBundleURLSchemes': ['http', 'https']
    },
    {
        'CFBundleURLName': 'local file URLs',
        'CFBundleURLSchemes': ['file']
    }
]

pl['CFBundleDocumentTypes'] = document_types
pl['CFBundleURLTypes'] = url_types

with open(plist_path, 'wb') as f:
    plistlib.dump(pl, f)
