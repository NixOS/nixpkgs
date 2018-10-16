#!/usr/bin/env python3

from pprint import pprint
import xml.etree.ElementTree as ET
import subprocess
import json
import os
import glob
import itertools
import sys
import shlex
import argparse

def debug(msg):
    print(msg, file=sys.stderr)

def indent(string, by):
    return "\n".join(["{}{}".format(by, line) for line in string.split("\n")])

def find_examples(tree):
    ns = {
        'docbook': 'http://docbook.org/ns/docbook',
    }

    for example in tree.findall('.//docbook:example', ns):
        xml_id = example.attrib['{http://www.w3.org/XML/1998/namespace}id']

        title = example.find('docbook:title', ns)
        if xml_id is None and title is None:
            debug('Skipping <example> with no <title> or xml:id')
            continue
        elif xml_id is None:
            debug('Skipping <example> with title "{}" because it has no xml:id'.format(title.text))
            continue

        code = example.find('.//docbook:programlisting[@role="input"]', ns)
        if code is None:
            debug('Skipping example {}: no <programlisting role="input">'.format(xml_id))
            continue

        expect = example.find('.//docbook:programlisting[@role="output"]', ns)
        if expect is None:
            debug('Skipping example {}: no <programlisting role="output">'.format(xml_id))
            continue

        context = example.find('.//docbook:programlisting[@role="context"]', ns)
        if context is None:
            context = '{}'
        else:
            context = context.text

        yield {
            "id": xml_id,
            "context": context,
            "code": code.text,
            "expect": expect.text,
        }

def print_success(example):
    print("{}: pass".format(example['id']))

def print_failure(example, full_expression, result):
    print("--------  Doc test failure  --------")
    print("ID: {}".format(example['id']))
    print("Executing:")
    print("")
    print(full_expression)
    print("")
    print("Expecting:")
    print(indent(example['expect'], "  "))
    print("Found:")
    print(indent(result['actual'], "  "))
    print("----")

def print_execution_failure(example, full_expression, exception):
    print("--------  Doc test execution failure  --------")
    print("ID: {}".format(example['id']))
    print("Evaluating the Nix expression:")
    print("")
    print(full_expression)
    print("")
    print("with the following command failed with exit code {}:".format(exception.returncode))
    print("")
    print(indent(" ".join([shlex.quote(part) for part in exception.cmd]), "    "))
    print("")
    print("and the command printed:")
    print(indent(exception.output.decode("utf-8"), "  "))

def main():
    parser = argparse.ArgumentParser(description='Execute doc tests for the Nixpkgs manual..')
    default_lib_dir = os.path.realpath(os.path.dirname(os.path.dirname(os.path.realpath(__file__)) + "/../../../lib/"))
    parser.add_argument('--lib-dir', dest='library_dir', type=os.path.realpath,
                        default=default_lib_dir,
                        help='Source of the library to test against (default: {})'.format(default_lib_dir))
    parser.add_argument('ids', metavar='id', type=str, nargs='*',
                        help='an example ID to test')

    args = parser.parse_args()

    doc_root = os.path.dirname(os.path.realpath(__file__))
    all_doc_files = glob.glob("{}/*.xml".format(doc_root))

    all_docs = (ET.parse(filename) for filename in all_doc_files)
    all_examples = itertools.chain(*(find_examples(doc) for doc in all_docs))

    if args.ids:
        checklist = args.ids
        filtered_examples = itertools.filterfalse(
            (lambda ex: ex['id'] not in checklist),
            all_examples
        )
    else:
        filtered_examples = all_examples

    passed = 0
    failed = []

    for example in filtered_examples:
        full_expression = """
          {{
            actual = let
                lib = import {};
                context = ({}
                );
              in with context; ({}
              );
            expect = (\n{}
            );
          }}
        """.format(args.library_dir,
                   indent(example['context'], "                  "),
                   indent(example['code'], "                  "),
                   indent(example['expect'], "              "))

        try:
            results = subprocess.check_output(["nix-instantiate", "--eval", "--json",
                                    "--strict", "-E", full_expression],
                                    stderr=subprocess.STDOUT
                                    )
        except subprocess.CalledProcessError as e:
            print_execution_failure(example, full_expression, e)
            failed.append(example['id'])
            continue

        parsed = json.loads(results)

        if parsed['expect'] == parsed['actual']:
            passed += 1
            print_success(example)
        else:
            print_failure(example, full_expression, parsed)
            failed.append(example['id'])

    print("{} passed, {} failed".format(passed, len(failed)))

    if failed != []:
        print("Retry failing examples with:")
        print("{} --lib-dir {} {}".format(
            __file__,
            shlex.quote(args.library_dir),
            " ".join([shlex.quote(id) for id in failed])))
        exit(1)

if __name__ == "__main__":
    main()
