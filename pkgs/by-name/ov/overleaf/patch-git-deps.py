#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p git nix-prefetch-git nodejs_18

import argparse
import json
import logging
import os
import re
import subprocess

logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')


def read_package_json(file_path):
    """Read and parse the package.json file."""
    with open(file_path, 'r') as file:
        logging.info(f'Reading package.json from {file_path}')
        return json.load(file)


def clone_git_dependency(name, url, rev, libraries_path):
    """Clone the git dependency as a submodule in the libraries directory."""
    dep_path = os.path.join(libraries_path, name)
    logging.info(f'Cloning {url} into {dep_path}')

    try:
        if rev:
            subprocess.run(['git', 'submodule', 'add', '-f',
                           url, dep_path], check=True)
            subprocess.run(
                ["git", "-C", dep_path, "checkout", rev], check=True)
        subprocess.run(['git', 'submodule', 'update', '--init',
                       '--recursive', dep_path], check=True)
    except subprocess.CalledProcessError as e:
        logging.error(f"Error cloning repository {url}: {e}")

    return dep_path


def patch_package_json(file_path, name, local_path):
    """Patch the package.json to replace the git dependency with a local file dependency."""
    logging.info(
        f'Patching {file_path} to replace {name} with local path {local_path}')
    try:
        with open(file_path, 'r') as file:
            package_data = json.load(file)

        # Update dependencies
        if 'dependencies' in package_data and name in package_data['dependencies']:
            package_data['dependencies'][name] = f"file:{local_path}"

        # Update devDependencies
        if 'devDependencies' in package_data and name in package_data['devDependencies']:
            package_data['devDependencies'][name] = f"file:{local_path}"

        with open(file_path, 'w') as file:
            json.dump(package_data, file, indent=2)

        logging.info(f'Successfully patched {file_path}')
    except Exception as e:
        logging.error(f"Error patching {file_path}: {e}")


def extract_git_dependencies(dependencies, package_json_path):
    """Extract Git dependencies from the provided dependencies dictionary."""
    logging.info('Extracting git dependencies')
    git_deps = {}
    git_url_pattern = re.compile(r'^(git|overleaf)')
    libraries_path = os.path.join(
        os.path.dirname("."), 'libraries')

    for key, value in dependencies.items():
        # Extract the URL and revision if present
        if isinstance(value, str) and git_url_pattern.match(value):
            logging.info(f'Found git dependency: {key} -> {value}')
            if value.startswith('github:'):
                value = value[len('github:'):]
            value = 'https://github.com/' + value

            if '#' in value:
                url, rev = value.split('#', 1)
                url = url.strip()
                rev = rev.strip()
            else:
                url, rev = value.strip(), None

            repo_name = url.rstrip('/').split('/')[-1]
            # Clone the repository
            local_path = clone_git_dependency(
                repo_name, url, rev, libraries_path)

            # Patch the package.json to use the local path
            patch_package_json(package_json_path, key, local_path)

            # Create the transformed JSON format
            git_deps[repo_name] = {
                'url': url,
                'rev': rev
            }

            logging.info(
                f'Transformed and cloned git dependency: {key} -> {git_deps[repo_name]}')

    return git_deps


def prefetch_git_dependency(name, value):
    """Run the external script on the Git URL and return the parsed JSON result."""
    try:
        result = subprocess.run(["nix-prefetch-git", "--rev", value['rev'], "--quiet",
                                 "--url", value['url']],
                                capture_output=True, text=True, check=True)
        json_result = json.loads(result.stdout)
        # Filter the result to only include url and hash
        filtered_result = {
            'url': json_result.get('url'),
            'rev': json_result.get('rev'),
            'hash': json_result.get('hash')
        }
        return filtered_result
    except subprocess.CalledProcessError as e:
        print(f"Error running script on {name}: {e}")
        return None
    except json.JSONDecodeError as e:
        print(f"Error decoding JSON from script output: {e}")
        return None


def find_all_package_json_files(root_dir):
    """Find all package.json files in the given directory and its subdirectories."""
    package_json_files = []
    for root, _, files in os.walk(root_dir):
        if 'package.json' in files:
            package_json_files.append(os.path.join(root, 'package.json'))
    return package_json_files


def main(output_file):
    """Main function to extract and process git dependencies."""
    logging.info('Starting main process')

    # Find all package.json files
    package_json_files = find_all_package_json_files('.')
    logging.info(f'Found {len(package_json_files)} package.json files')

    all_git_dependencies = {}

    for package_json_path in package_json_files:
        # Load the package.json
        package_data = read_package_json(package_json_path)

        if package_data:
            # Extract dependencies
            dependencies = package_data.get('dependencies', {})
            dev_dependencies = package_data.get('devDependencies', {})
            all_dependencies = {**dependencies, **dev_dependencies}

            # Get git dependencies
            git_dependencies = extract_git_dependencies(
                all_dependencies, package_json_path)
            all_git_dependencies.update(git_dependencies)

    # Process each git dependency using the external script
    final_result = {}
    for name, value in all_git_dependencies.items():
        result = prefetch_git_dependency(name, value)
        if result:
            final_result[name] = result

    # Output final result
    with open(output_file, 'w') as file:
        json.dump(final_result, file, indent=2)
        logging.info(f"Saved git dependencies to {output_file}")

    try:
        logging.info("Updating package-lock.json...")
        result = subprocess.run(["npm", "i", "--package-lock-only", "--ignore-scripts"],
                                capture_output=True, text=True, check=True)
        logging.info("Updated package-lock.json")
    except subprocess.CalledProcessError as e:
        print(f"Error updating package-lock.json: {e}")
        return None


# Example usage:
if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='Process and transform NPM git dependencies.')
    parser.add_argument('output_file', type=str,
                        help='Path to the output JSON file.')
    args = parser.parse_args()

    main(args.output_file)
