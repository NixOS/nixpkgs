import os
import json

# Find and modify all package.json files recursively
for root, dirs, files in os.walk('.'):
    for file in files:
        if file == 'package.json':
            filepath = os.path.join(root, file)
            try:
                with open(filepath, 'r') as f:
                    data = json.load(f)
                modified = False

                # Exclude non-required workspaces from root package.json
                if filepath == './package.json':
                    if 'workspaces' in data:
                        data['workspaces'] = [
                            w for w in data['workspaces']
                            if w not in ['packages/insomnia-smoke-test', 'packages/insomnia-inso']
                        ]
                        modified = True

                # Convert git dependency to standard registry dependency and add lodash.set missing deps
                if filepath == './packages/insomnia/package.json':
                    if 'dependencies' in data:
                        data['dependencies']['grpc-reflection-js'] = '^0.3.0'
                        data['dependencies']['lodash.set'] = '^4.3.2'
                        data['dependencies']['@types/lodash.set'] = '^4.3.9'
                        data['dependencies']['@types/lodash'] = '^4.17.25'
                        modified = True

                for section in ['dependencies', 'devDependencies', 'optionalDependencies', 'peerDependencies']:
                    if section in data:
                        if '@kong/insomnia-plugin-ai' in data[section]:
                            data[section].pop('@kong/insomnia-plugin-ai')
                            modified = True
                        if '@kong/insomnia-plugin-external-vault' in data[section]:
                            data[section].pop('@kong/insomnia-plugin-external-vault')
                            modified = True
                if modified:
                    with open(filepath, 'w') as f:
                        json.dump(data, f, indent=2)
                    print(f"Patched {filepath}")
            except Exception as e:
                print(f"Failed to patch {filepath}: {e}")

# Modify package-lock.json
with open('package-lock.json', 'r') as f:
    lock = json.load(f)
if 'packages' in lock:
    # Exclude from workspaces list of root package in lockfile
    if "" in lock['packages'] and 'workspaces' in lock['packages'][""]:
        lock['packages'][""]['workspaces'] = [
            w for w in lock['packages'][""]['workspaces']
            if w not in ['packages/insomnia-smoke-test', 'packages/insomnia-inso']
        ]

    # Update node_modules/grpc-reflection-js entry to use standard registry tgz with integrity hash
    if 'node_modules/grpc-reflection-js' in lock['packages']:
        pkg = lock['packages']['node_modules/grpc-reflection-js']
        pkg['resolved'] = 'https://registry.npmjs.org/grpc-reflection-js/-/grpc-reflection-js-0.3.0.tgz'
        pkg['integrity'] = 'sha512-3lhTlQluPxVgbowCXA3tAZC3RJW+GSOUkguLNYl1QffYRiutUB3RDfPkQFTcrCFJgNiIIxx+iJkr8s3uSp3zWA=='
        pkg.pop('resolvedEnv', None)

    # Inject lodash.set, @types/lodash.set, and @types/lodash entries
    lock['packages']['node_modules/lodash.set'] = {
        "version": "4.3.2",
        "resolved": "https://registry.npmjs.org/lodash.set/-/lodash.set-4.3.2.tgz",
        "integrity": "sha512-4hNPN5jlm/N/HLMCO43v8BXKq9Z7QdAGc/VGrRD61w8gN9g/6jF9A4L1pbUgBLCffi0w9VsXfTOij5x8iTyFvg==",
        "license": "MIT"
    }
    lock['packages']['node_modules/@types/lodash.set'] = {
        "version": "4.3.9",
        "resolved": "https://registry.npmjs.org/@types/lodash.set/-/lodash.set-4.3.9.tgz",
        "integrity": "sha512-KOxyNkZpbaggVmqbpr82N2tDVTx05/3/j0f50Es1prxrWB0XYf9p3QNxqcbWb7P1Q9wlvsUSlCFnwlPCIJ46PQ==",
        "license": "MIT",
        "dependencies": {
            "@types/lodash": "*"
        }
    }
    lock['packages']['node_modules/@types/lodash'] = {
        "version": "4.17.25",
        "resolved": "https://registry.npmjs.org/@types/lodash/-/lodash-4.17.25.tgz",
        "integrity": "sha512-+K1NIO8I+F9/wNulfVvu23QYd0Pe9/OCqRrim4NoYIf1VoEDL90Ve4ClzpyqBLc7NpGGWRvYNCKZ1BE/Jpf8dQ==",
        "license": "MIT"
    }

    # Inject into packages/insomnia dependencies in lockfile
    if 'packages/insomnia' in lock['packages']:
        insomnia_lock_pkg = lock['packages']['packages/insomnia']
        if 'dependencies' not in insomnia_lock_pkg:
            insomnia_lock_pkg['dependencies'] = {}
        insomnia_lock_pkg['dependencies']['grpc-reflection-js'] = '^0.3.0'
        insomnia_lock_pkg['dependencies']['lodash.set'] = '^4.3.2'
        insomnia_lock_pkg['dependencies']['@types/lodash.set'] = '^4.3.9'
        insomnia_lock_pkg['dependencies']['@types/lodash'] = '^4.17.25'

    keys_to_delete = []
    for k in lock['packages']:
        if k in [
            'node_modules/@kong/insomnia-plugin-ai',
            'node_modules/@kong/insomnia-plugin-external-vault',
            'node_modules/insomnia-inso',
            'node_modules/insomnia-smoke-test'
        ] or \
           k.startswith('node_modules/@kong/insomnia-plugin-ai/') or \
           k.startswith('node_modules/@kong/insomnia-plugin-external-vault/') or \
           k.startswith('node_modules/insomnia-inso/') or \
           k.startswith('node_modules/insomnia-smoke-test/') or \
           k.startswith('packages/insomnia-smoke-test') or \
           k.startswith('packages/insomnia-inso'):
            keys_to_delete.append(k)
    for k in keys_to_delete:
        lock['packages'].pop(k)
    for pkg_name, pkg in lock['packages'].items():
        for section in ['dependencies', 'devDependencies', 'optionalDependencies', 'peerDependencies']:
            if section in pkg:
                pkg[section].pop('@kong/insomnia-plugin-ai', None)
                pkg[section].pop('@kong/insomnia-plugin-external-vault', None)

    # Map of known missing resolutions and integrity hashes
    integrity_map = {
        "@testing-library/dom@10.4.1": "sha512-o4PXJQidqJl82ckFaXUeoAW+XysPLauYI43Abki5hABd853iMhitooc6znOnczgbTYmEP6U6/y1ZyKAIsvMKGg==",
        "@testing-library/react@16.3.0": "sha512-kFSyxiEDwv1WLl2fgsq6pPBbw5aWKrsY2/noi1Id0TK0UParSF62oFQFGHXIyaG4pp2tEub/Zlel+fjjZILDsw==",
        "aria-query@5.3.0": "sha512-b0P0sZPKtyu8HkeRAfCq0IfURZK+SuwMjY1UXGBU27wpAiTwQAIlq56IbIO+ytk/JjS1fMR14ee5WBBfKi5J6A==",
        "tailwind-merge@2.6.0": "sha512-P+Vu1qXfzediirmHOC3xKGAYeZtPcV9g76X+xg2FD4tYgR71ewMA35Y3sCz3zhiN/dwefRpJX0yBcgwi1fXNQA=="
    }

    # Synthesize missing resolved URLs for nested registry packages
    for k, pkg in lock['packages'].items():
        if k != "" and 'resolved' not in pkg:
            parts = k.split('node_modules/')
            if len(parts) > 1:
                pkg_name = parts[-1]
                version = pkg.get('version')
                if version:
                    map_key = f"{pkg_name}@{version}"
                    if map_key in integrity_map:
                        pkg['resolved'] = f"https://registry.npmjs.org/{pkg_name}/-/{pkg_name.split('/')[-1]}-{version}.tgz"
                        pkg['integrity'] = integrity_map[map_key]

    # Translate any remaining git+ssh to git+https
    for k, pkg in lock['packages'].items():
        if 'resolved' in pkg and pkg['resolved'].startswith('git+ssh://git@github.com/'):
            pkg['resolved'] = pkg['resolved'].replace('git+ssh://git@github.com/', 'git+https://github.com/')

with open('package-lock.json', 'w') as f:
    json.dump(lock, f, indent=2)
