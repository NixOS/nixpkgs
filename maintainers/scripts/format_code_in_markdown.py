#!/usr/bin/env python3

'''
Utility to automatically detect indentation issues in code blocks in markdown files
and to fix them. Shows its usage when called without any arguments.

I am very sorry for anyone who reads this and understands Python well :( I know the
code quality is not the best but the script does the job as far as I can tell.
'''

import difflib
import fnmatch
import os
import subprocess
import sys


def usage() -> None:
    '''Prints the usage and quits afterwards...'''
    print(f'Usage: {sys.argv[0]} <check|fix> <file_or_dir..>', file=sys.stderr)
    print(file=sys.stderr)
    print('When a directory is given, it is recursively searched for *.md files')
    sys.exit(1)


def locate_formatter_binary(nixpkgs_root, attr, binary) -> str:
    '''Returns the path to a formatter that is evaluated from the current nixpkgs.'''
    path = subprocess.run(['nix-build', '-A', attr], stdout=subprocess.PIPE, cwd=nixpkgs_root).stdout.decode('utf-8').strip()
    path += f'/bin/{binary}'
    return path


def call_formatter(formatter_path, block_start, block) -> (int, str, str):
    '''Calls a formatter for a block, returning a tuple of (return_code, stdout, stderr)'''
    # We pad with newlines so the offets of the formatter errors
    # are correct in the error messages we print when the code is not
    # valid.
    dummy_file = (('\n' * block_start) + block).encode('utf-8')
    proc = subprocess.run([formatter_path], input=dummy_file, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    # The strip() leaves us without the leading newlines we inserted in the dummy file. We do however need to
    # re-add the last newline :/
    return (proc.returncode, proc.stdout.decode('utf-8').strip() + '\n', proc.stderr.decode('utf-8').strip())


def replace_block(filepath, block_start, block_length, block_indentation, formatted) -> str:
    '''Returns the contents of the file with a single block replaced.'''
    # Read the start
    with open(filepath) as input_file:
        new_file_contents = [next(input_file) for _ in range(block_start)]
    # Insert the block
    new_file_contents += [(block_indentation if x.strip() != '' else '') + x for x in formatted.splitlines(keepends=True)]
    # Read the rest
    with open(filepath) as input_file:
        for _ in range(block_start + block_length):
            next(input_file)
        new_file_contents += input_file

    return new_file_contents


def render_diff(filepath, block_start, block_length, block_indentation, formatted) -> None:
    '''Renders a diff between the formatted and non-formatted files'''
    with open(filepath) as f:
        old_file_contents = f.read().splitlines(keepends=True)
    new_file_contents = replace_block(filepath, block_start, len(block.splitlines()), block_indentation, formatted)
    sys.stdout.writelines(difflib.unified_diff(old_file_contents, new_file_contents, fromfile=filepath, tofile=filepath))


# Parameter parsing
if len(sys.argv) < 3:
    usage()

if sys.argv[1] != 'check' and sys.argv[1] != 'fix':
    usage()

# Find files
files = []
fail = False
for arg in sys.argv[2:]:
    if os.path.isfile(arg):
        files += [arg]
    elif os.path.isdir(arg):
        for root, _, filenames in os.walk(arg):
            for filename in fnmatch.filter(filenames, '*.md'):
                files += [os.path.join(root, filename)]
    else:
        print(f'{arg} not found', file=sys.stderr)
        fail = True
if fail:
    sys.exit(1)

# Find formatters
nixpkgs_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
nixfmt_path = locate_formatter_binary(nixpkgs_root, 'nixfmt-rfc-style', 'nixfmt')


# Configure formatters
class Formatter(object):
    def error_handler(stderr, block_indentation) -> None:
        '''Function that is called when the formatter returns a non-success exit code.'''
        print(stderr, file=sys.stderr)


class NixfmtFormatter(Formatter):
    def binary() -> str:
        '''Returns the path to the nixfmt binary.'''
        return nixfmt_path

    def error_handler(stderr, block_indentation) -> None:
        '''Function that is called when the formatter returns a non-success exit code.'''
        out = stderr.replace('<stdin>:', f'{filepath}:')
        for line in out.splitlines():
            if '|' in line:
                # Fix the indentation we stripped out and print the lines
                print(line.replace('|', f'|{block_indentation}', 1), file=sys.stderr)
            else:
                print(line, file=sys.stderr)


# Register formatters
formatters = {
    'nix': NixfmtFormatter,
}

block_start = 0
block_indentation = None
block = ''
language = ''
fail = False
while files:
    filepath = files.pop()
    with open(filepath, 'r+') as file:
        for lineno, line in enumerate(file):
            if '```' in line:
                if block_indentation is None:
                    # Start of a block
                    parts = line.split('`')
                    block_indentation = parts[0]
                    language = parts[-1].strip()
                    block_start = lineno + 1
                else:
                    # End of a block
                    if language in formatters:
                        formatter = formatters[language]

                        (rc, stdout, stderr) = call_formatter(formatter.binary(), block_start, block)
                        if rc != 0:
                            if fail:
                                print(file=sys.stderr)
                            formatter.error_handler(stderr, block_indentation)
                            fail = True
                        elif stdout != block:
                            # We have the valid code, let's see if we need to replace anything or just error out.
                            if sys.argv[1] == 'check':
                                if fail:
                                    print(file=sys.stderr)
                                fail = True  # :(
                                print(f'Wrong format of {language} code in {filepath}, block starting from line {block_start}', file=sys.stderr)
                                render_diff(filepath, block_start, block.count('\n'), block_indentation, stdout)
                            elif sys.argv[1] == 'fix':
                                print(f'Autofixing wrong format of {language} code in {filepath}, block starting from line {block_start}', file=sys.stderr)
                                new_contents = replace_block(filepath, block_start, block.count('\n'), block_indentation, stdout)
                                file.seek(0)
                                file.write(''.join(new_contents))
                                file.truncate()
                                files += [filepath]
                                # Reset state
                                block_start = 0
                                block_indentation = None
                                block = ''
                                language = ''
                                break
                    # Reset state
                    block_start = 0
                    block_indentation = None
                    block = ''
                    language = ''
            elif block_indentation is not None:
                block += line.removeprefix(block_indentation)

if fail:
    if os.getenv('CI'):
        print(file=sys.stderr)
        print('-----', file=sys.stderr)
        print(f'If the formatting is wrong, run `{os.path.relpath(__file__, nixpkgs_root)} fix .` from your nixpkgs root.', file=sys.stderr)
        print('-----', file=sys.stderr)
    sys.exit(1)
