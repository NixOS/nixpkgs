import collections
import json
import sys

class Key:
    def __init__(self, path):
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
def pivot(options):
    result = dict()
    for (name, opt) in options.items():
        result[Key(opt['loc'])] = Option(name, opt)
    return result

# pivot back to indexed-by-full-name
# like the docbook build we'll just fail if multiple options with differing locs
# render to the same option name.
def unpivot(options):
    result = dict()
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

options = pivot(json.load(open(sys.argv[1], 'r')))
overrides = pivot(json.load(open(sys.argv[2], 'r')))

# fix up declaration paths in lazy options, since we don't eval them from a full nixpkgs dir
for (k, v) in options.items():
    v.value['declarations'] = list(map(lambda s: f'nixos/modules/{s}', v.value['declarations']))

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

# check that every option has a description
# TODO: nixos-rebuild with flakes may hide the warning, maybe turn on -L by default for those?
for (k, v) in options.items():
    if v.value.get('description', None) is None:
        print(f"\x1b[1;31mwarning: option {v.name} has no description\x1b[0m", file=sys.stderr)
        v.value['description'] = "This option has no description."

json.dump(unpivot(options), fp=sys.stdout)
