# Ugliest Python code I've ever written. -- aszlig
import sys

def get_plist(path):
    in_pack = False
    in_str = False
    current_key = None
    buf = ""
    packages = {}
    package_name = None
    package_attrs = {}
    with open(path, 'r') as setup:
        for line in setup:
            if in_str and line.rstrip().endswith('"'):
                package_attrs[current_key] = buf + line.rstrip()[:-1]
                in_str = False
                continue
            elif in_str:
                buf += line
                continue

            if line.startswith('@'):
                in_pack = True
                package_name = line[1:].strip()
                package_attrs = {}
            elif in_pack and ':' in line:
                key, value = line.split(':', 1)
                if value.lstrip().startswith('"'):
                    if value.lstrip()[1:].rstrip().endswith('"'):
                        value = value.strip().strip('"')
                    else:
                        in_str = True
                        current_key = key.strip().lower()
                        buf = value.lstrip()[1:]
                        continue
                package_attrs[key.strip().lower()] = value.strip()
            elif in_pack:
                in_pack = False
                packages[package_name] = package_attrs
    return packages

def main():
    packages = get_plist(sys.argv[1])
    to_include = set()

    def traverse(package):
        to_include.add(package)
        attrs = packages.get(package, {})
        deps = attrs.get('requires', '').split()
        for new_dep in set(deps) - to_include:
            traverse(new_dep)

    map(traverse, sys.argv[2:])

    sys.stdout.write('[\n')
    for package, attrs in packages.iteritems():
        if package not in to_include:
            cats = [c.lower() for c in attrs.get('category', '').split()]
            if 'base' not in cats:
                continue

        install_line = attrs.get('install')
        if install_line is None:
            continue

        url, size, md5 = install_line.split(' ', 2)

        pack = [
            '  {',
            '    url = "{0}";'.format(url),
            '    md5 = "{0}";'.format(md5),
            '  }',
        ];
        sys.stdout.write('\n'.join(pack) + '\n')
    sys.stdout.write(']\n')

if __name__ == '__main__':
    main()
