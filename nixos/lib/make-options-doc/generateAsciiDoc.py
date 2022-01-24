import json
import sys

options = json.load(sys.stdin)
# TODO: declarations: link to github
for (name, value) in options.items():
    print(f'== {name}')
    print()
    print(value['description'])
    print()
    print('[discrete]')
    print('=== details')
    print()
    print(f'Type:: {value["type"]}')
    if 'default' in value:
        print('Default::')
        print('+')
        print('----')
        print(json.dumps(value['default'], ensure_ascii=False, separators=(',', ':')))
        print('----')
        print()
    else:
        print('No Default:: {blank}')
    if value['readOnly']:
        print('Read Only:: {blank}')
    else:
        print()
    if 'example' in value:
        print('Example::')
        print('+')
        print('----')
        print(json.dumps(value['example'], ensure_ascii=False, separators=(',', ':')))
        print('----')
        print()
    else:
        print('No Example:: {blank}')
    print()
