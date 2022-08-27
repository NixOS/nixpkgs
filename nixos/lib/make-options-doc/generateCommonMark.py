import json
import sys
import html

options = json.load(sys.stdin)
for (name, value) in options.items():
    print('##', html.escape(name))
    print(value['description'])
    print()
    if 'type' in value:
        print('*_Type_*:')
        print(value['type'])
        print()
    print()
    if 'default' in value:
        print('*_Default_*')
        print('```')
        print(json.dumps(value['default'], ensure_ascii=False, separators=(',', ':')))
        print('```')
    print()
    print()
    if 'example' in value:
        print('*_Example_*')
        print('```')
        print(json.dumps(value['example'], ensure_ascii=False, separators=(',', ':')))
        print('```')
    print()
    print()
