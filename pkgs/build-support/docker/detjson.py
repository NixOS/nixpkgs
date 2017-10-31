#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Deterministic layer json: https://github.com/docker/hub-feedback/issues/488

import sys
reload(sys)
sys.setdefaultencoding('UTF8')
import json

# If any of the keys below are equal to a certain value
# then we can delete it because it's the default value
SAFEDELS = {
    "Size": 0,
    "config": {
        "ExposedPorts": None,
        "MacAddress": "",
        "NetworkDisabled": False,
        "PortSpecs": None,
        "VolumeDriver": ""
    }
}
SAFEDELS["container_config"] = SAFEDELS["config"]

def makedet(j, safedels):
    for k,v in safedels.items():
        if k not in j:
            continue
        if type(v) == dict:
            makedet(j[k], v)
        elif j[k] == v:
            del j[k]

def main():
    j = json.load(sys.stdin)
    makedet(j, SAFEDELS)
    json.dump(j, sys.stdout, sort_keys=True)

if __name__ == '__main__':
    main()