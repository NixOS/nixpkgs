import json
import sys

available_layers = int(sys.argv[1])
pkgs = [x.strip() for x in sys.stdin.readlines()]

# Layers [2, limit] have 1 pkg each, of the user's top-most pkgs,
# and layer 1 has the remainder.
user_pkgs = pkgs[-(available_layers - 1):]
layers = [pkgs[:-(available_layers - 1)]]

for pkg in user_pkgs:
    layers.append([pkg])

print(json.dumps(layers))
