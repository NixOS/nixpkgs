import json
import sys

from typing import Dict, Set

# this compresses MITM URL lists with Gradle-specific optimizations
# specifically, it splits each url into up to 3 parts - they will be
# concatenated like part1/part2.part3 or part1.part2
# part3 is simply always the file extension, but part1 and part2 is
# optimized using special heuristics
# additionally, if part2 ends with /a/b/{a}-{b}, the all occurences of
# /{a}/{b}/ are replaced with #
# finally, anything that ends with = is considered SHA256, anything that
# starts with http is considered a redirect URL, anything else is
# considered text

with open(sys.argv[1], 'rt') as f:
    data: dict = json.load(f)

new_data: Dict[str, Dict[str, Dict[str, dict]]] = {}

for url, info in data.items():
    ext, base = map(lambda x: x[::-1], url[::-1].split('.', 1))
    if base.endswith('.tar'):
        base = base[:-4]
        ext = 'tar.' + ext
    if ext in ['jar', 'pom', 'module']:
        comps = base.split('/')
        if '-' in comps[-1]:
            ver, name = map(lambda x: x[::-1], comps[-1][::-1].split('-', 1))
            if f'{comps[-3]}-{comps[-2]}' == f'{name}-{ver}':
                name = comps[-3]
                ver = comps[-2]
            if f'/{name}/{ver}/' in base:
                base = '/'.join(comps[:-1]) + '/'
                base = base.replace(f'/{name}/{ver}/', '#')
                base = base + f'{name}/{ver}'
    scheme, rest = base.split('/', 1)
    if scheme not in new_data.keys():
        new_data[scheme] = {}
    if rest not in new_data[scheme].keys():
        new_data[scheme][rest] = {}
    if 'sha256' in info.keys():
        new_data[scheme][rest][ext] = info['sha256']
    elif 'text' in info.keys():
        new_data[scheme][rest][ext] = info['text']
    elif 'redirect' in info.keys():
        new_data[scheme][rest][ext] = info['redirect']
    else:
        raise Exception('Unknown key: ' + repr(info))

data = new_data
changed = True
while changed:
    changed = False
    new_data = {}
    for part1, info1 in data.items():
        starts: Set[str] = set()
        lose = 0
        win = 0
        count = 0
        for part2, info2 in info1.items():
            if '/' not in part2:
                count = 0
                break
            st = part2.split('/', 1)[0]
            if st not in starts:
                lose += len(st) + 1
                count += 1
                starts.add(st)
            win += len(st) + 1
        if count == 0:
            new_data[part1] = info1
            continue
        # always separate domains, but only descend further if there's
        # only one subdir (for more unified syntax/so diffs are nicer)
        if count != 1 and '.' in part1:
            new_data[part1] = info1
            continue
        lose += (count - 1) * max(0, len(part1) - 4)
        if win > lose or ('.' not in part1 and win >= lose):
            changed = True
            for part2, info2 in info1.items():
                st, part3 = part2.split('/', 1)
                new_part1 = part1 + '/' + st
                if new_part1 not in new_data.keys():
                    new_data[new_part1] = {}
                new_data[new_part1][part3] = info2
        else:
            new_data[part1] = info1
    data = new_data

with open(sys.argv[2], 'wt') as f:
    json.dump(new_data, f, sort_keys=True, indent=1)
    f.write('\n')
