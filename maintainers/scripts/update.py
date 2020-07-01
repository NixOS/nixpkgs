import argparse
import concurrent.futures
import json
import os
import subprocess
import sys

updates = {}

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def run_update_script(package):
    eprint(f" - {package['name']}: UPDATING ...")

    subprocess.run(package['updateScript'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, check=True)


def main(max_workers, keep_going, packages):
    with open(sys.argv[1]) as f:
        packages = json.load(f)

    eprint()
    eprint('Going to be running update for following packages:')
    for package in packages:
        eprint(f" - {package['name']}")
    eprint()

    confirm = input('Press Enter key to continue...')
    if confirm == '':
        eprint()
        eprint('Running update for:')

        with concurrent.futures.ProcessPoolExecutor(max_workers=max_workers) as executor:
            for package in packages:
                updates[executor.submit(run_update_script, package)] = package

            for future in concurrent.futures.as_completed(updates):
                package = updates[future]

                try:
                    future.result()
                    eprint(f" - {package['name']}: DONE.")
                except subprocess.CalledProcessError as e:
                    eprint(f" - {package['name']}: ERROR")
                    eprint()
                    eprint(f"--- SHOWING ERROR LOG FOR {package['name']} ----------------------")
                    eprint()
                    eprint(e.stdout.decode('utf-8'))
                    with open(f"{package['pname']}.log", 'wb') as f:
                        f.write(e.stdout)
                    eprint()
                    eprint(f"--- SHOWING ERROR LOG FOR {package['name']} ----------------------")

                    if not keep_going:
                        sys.exit(1)

        eprint()
        eprint('Packages updated!')
        sys.exit()
    else:
        eprint('Aborting!')
        sys.exit(130)

parser = argparse.ArgumentParser(description='Update packages')
parser.add_argument('--max-workers', '-j', dest='max_workers', type=int, help='Number of updates to run concurrently', nargs='?', default=4)
parser.add_argument('--keep-going', '-k', dest='keep_going', action='store_true', help='Do not stop after first failure')
parser.add_argument('packages', help='JSON file containing the list of package names and their update scripts')

if __name__ == '__main__':
    args = parser.parse_args()

    try:
        main(args.max_workers, args.keep_going, args.packages)
    except (KeyboardInterrupt, SystemExit) as e:
        for update in updates:
            update.cancel()

        sys.exit(e.code if isinstance(e, SystemExit) else 130)
