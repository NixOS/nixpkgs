import os
import toml

rust_src = os.environ['RUSTC_SRC']
orig_cargo = os.environ['ORIG_CARGO'] if 'ORIG_CARGO' in os.environ else None

base = {
  'package': {
    'name': 'alloc',
    'version': '0.0.0',
    'authors': ['The Rust Project Developers'],
    'edition': '2018',
  },
  'dependencies': {
    'compiler_builtins': {
      'version': '0.1.0',
      'features': ['rustc-dep-of-std', 'mem'],
    },
    'core': {
      'path': os.path.join(rust_src, 'libcore'),
    },
  },
  'lib': {
    'name': 'alloc',
    'path': os.path.join(rust_src, 'liballoc/lib.rs'),
  },
  'patch': {
    'crates-io': {
      'rustc-std-workspace-core': {
        'path': os.path.join(rust_src, 'tools/rustc-std-workspace-core'),
      },
    },
  },
}

if orig_cargo is not None:
  with open(orig_cargo, 'r') as f:
    src = toml.loads(f.read())
    if 'profile' in src:
      base['profile'] = src['profile']

out = toml.dumps(base)

with open('Cargo.toml', 'x') as f:
  f.write(out)
