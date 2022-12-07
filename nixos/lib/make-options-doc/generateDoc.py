import argparse
import json
import sys

formats = ['commonmark', 'asciidoc']

parser = argparse.ArgumentParser(
    description = 'Generate documentation for a set of JSON-formatted NixOS options'
)
parser.add_argument(
    'nix_options_path',
    help = 'a path to a JSON file containing the NixOS options'
)
parser.add_argument(
    '-f',
    '--format',
    choices = formats,
    required = True,
    help = f'the documentation format to generate'
)

args = parser.parse_args()

# Pretty-print certain Nix types, like literal expressions.
def render_types(obj):
    if '_type' not in obj: return obj

    _type = obj['_type']
    if _type == 'literalExpression' or _type == 'literalDocBook':
        return obj['text']

    if _type == 'derivation':
        return obj['name']

    raise Exception(f'Unexpected type `{_type}` in {json.dumps(obj)}')

def generate_commonmark(options):
    for (name, value) in options.items():
        print('##', name.replace('<', '&lt;').replace('>', '&gt;'))
        print(value['description'])
        print()
        if 'type' in value:
            print('*_Type_*')
            print ('```')
            print(value['type'])
            print ('```')
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

# TODO: declarations: link to github
def generate_asciidoc(options):
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

with open(args.nix_options_path) as nix_options_json:
    options = json.load(nix_options_json, object_hook=render_types)

    if args.format == 'commonmark':
        generate_commonmark(options)
    elif args.format == 'asciidoc':
        generate_asciidoc(options)
    else:
        raise Exception(f'Unsupported documentation format `--format {args.format}`')

