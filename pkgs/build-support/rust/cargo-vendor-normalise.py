#!/usr/bin/env python

import toml
import sys

def escape(s):
    return '"'+s.replace('"', r'\"').replace("\n", r"\n").replace("\\", "\\\\")+'"'

data = toml.load(sys.stdin)

assert list(data.keys()) == [ "source" ]

# this value is non deterministic
data["source"]["vendored-sources"]["directory"] = "@vendor@"

result = ""
inner = data["source"]
for source in sorted(inner.keys()):
    result += '[source.{}]\n'.format(escape(source))
    if source == "vendored-sources":
        result += '"directory" = "@vendor@"\n'
    else:
        for key in sorted(inner[source].keys()):
            result += '{} = {}\n'.format(escape(key), escape(inner[source][key]))
    result += "\n"

real = toml.loads(result)
assert real == data, "output = {} while input = {}".format(real, data)

print(result)


