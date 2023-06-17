import collections
import json
import os
import sys
from typing import Any, Dict, List

JSON = Dict[str, Any]

class Key:
    def __init__(self, path: List[str]):
        self.path = path
    def __hash__(self):
        result = 0
        for id in self.path:
            result ^= hash(id)
        return result
    def __eq__(self, other):
        return type(self) is type(other) and self.path == other.path

Option = collections.namedtuple('Option', ['name', 'value'])

# pivot a dict of options keyed by their display name to a dict keyed by their path
def pivot(options: Dict[str, JSON]) -> Dict[Key, Option]:
    result: Dict[Key, Option] = dict()
    for (name, opt) in options.items():
        result[Key(opt['loc'])] = Option(name, opt)
    return result

# pivot back to indexed-by-full-name
# like the docbook build we'll just fail if multiple options with differing locs
# render to the same option name.
def unpivot(options: Dict[Key, Option]) -> Dict[str, JSON]:
    result: Dict[str, Dict] = dict()
    for (key, opt) in options.items():
        if opt.name in result:
            raise RuntimeError(
                'multiple options with colliding ids found',
                opt.name,
                result[opt.name]['loc'],
                opt.value['loc'],
            )
        result[opt.name] = opt.value
    return result

warningsAreErrors = False
warnOnDocbook = False
errorOnDocbook = False
optOffset = 0
for arg in sys.argv[1:]:
    if arg == "--warnings-are-errors":
        optOffset += 1
        warningsAreErrors = True
    if arg == "--warn-on-docbook":
        optOffset += 1
        warnOnDocbook = True
    elif arg == "--error-on-docbook":
        optOffset += 1
        errorOnDocbook = True

options = pivot(json.load(open(sys.argv[1 + optOffset], 'r')))
overrides = pivot(json.load(open(sys.argv[2 + optOffset], 'r')))

# fix up declaration paths in lazy options, since we don't eval them from a full nixpkgs dir
for (k, v) in options.items():
    # The _module options are not declared in nixos/modules
    if v.value['loc'][0] != "_module":
        v.value['declarations'] = list(map(lambda s: f'nixos/modules/{s}' if isinstance(s, str) else s, v.value['declarations']))

# merge both descriptions
for (k, v) in overrides.items():
    cur = options.setdefault(k, v).value
    for (ok, ov) in v.value.items():
        if ok == 'declarations':
            decls = cur[ok]
            for d in ov:
                if d not in decls:
                    decls += [d]
        elif ok == "type":
            # ignore types of placeholder options
            if ov != "_unspecified" or cur[ok] == "_unspecified":
                cur[ok] = ov
        elif ov is not None or cur.get(ok, None) is None:
            cur[ok] = ov

severity = "error" if warningsAreErrors else "warning"

def is_docbook(o, key):
    val = o.get(key, {})
    if not isinstance(val, dict):
        return False
    return val.get('_type', '') == 'literalDocBook'

# check that every option has a description
hasWarnings = False
hasErrors = False
hasDocBook = False
for (k, v) in options.items():
    if warnOnDocbook or errorOnDocbook:
        kind = "error" if errorOnDocbook else "warning"
        if isinstance(v.value.get('description', {}), str):
            hasErrors |= errorOnDocbook
            hasDocBook = True
            print(
                f"\x1b[1;31m{kind}: option {v.name} description uses DocBook\x1b[0m",
                file=sys.stderr)
        elif is_docbook(v.value, 'defaultText'):
            hasErrors |= errorOnDocbook
            hasDocBook = True
            print(
                f"\x1b[1;31m{kind}: option {v.name} default uses DocBook\x1b[0m",
                file=sys.stderr)
        elif is_docbook(v.value, 'example'):
            hasErrors |= errorOnDocbook
            hasDocBook = True
            print(
                f"\x1b[1;31m{kind}: option {v.name} example uses DocBook\x1b[0m",
                file=sys.stderr)

    if v.value.get('description', None) is None:
        hasWarnings = True
        print(f"\x1b[1;31m{severity}: option {v.name} has no description\x1b[0m", file=sys.stderr)
        v.value['description'] = "This option has no description."
    if v.value.get('type', "unspecified") == "unspecified":
        hasWarnings = True
        print(
            f"\x1b[1;31m{severity}: option {v.name} has no type. Please specify a valid type, see " +
            "https://nixos.org/manual/nixos/stable/index.html#sec-option-types\x1b[0m", file=sys.stderr)

if hasDocBook:
    (why, what) = (
        ("disallowed for in-tree modules", "contribution") if errorOnDocbook
        else ("deprecated for option documentation", "module")
    )
    print("Explanation: The documentation contains descriptions, examples, or defaults written in DocBook. " +
        "NixOS is in the process of migrating from DocBook to Markdown, and " +
        f"DocBook is {why}. To change your {what} to "+
        "use Markdown, apply mdDoc and literalMD and use the *MD variants of option creation " +
        "functions where they are available. For example:\n" +
        "\n" +
        "  example.foo = mkOption {\n" +
        "    description = lib.mdDoc ''your description'';\n" +
        "    defaultText = lib.literalMD ''your description of default'';\n" +
        "  };\n" +
        "\n" +
        "  example.enable = mkEnableOption (lib.mdDoc ''your thing'');\n" +
        "  example.package = mkPackageOptionMD pkgs \"your-package\" {};\n" +
        "  imports = [ (mkAliasOptionModuleMD [ \"example\" \"args\" ] [ \"example\" \"settings\" ]) ];",
        file = sys.stderr)
    with open(os.getenv('TOUCH_IF_DB'), 'x'):
        # just make sure it exists
        pass

if hasErrors:
    sys.exit(1)
if hasWarnings and warningsAreErrors:
    print(
        "\x1b[1;31m" +
        "Treating warnings as errors. Set documentation.nixos.options.warningsAreErrors " +
        "to false to ignore these warnings." +
        "\x1b[0m",
        file=sys.stderr)
    sys.exit(1)

json.dump(unpivot(options), fp=sys.stdout)
