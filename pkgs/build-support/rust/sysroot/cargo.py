import os
import toml

rust_src = os.environ['RUSTC_SRC']
orig_cargo = os.environ['ORIG_CARGO'] if 'ORIG_CARGO' in os.environ else None

base = {
  'package': {
    'name': 'nixpkgs-sysroot-stub-crate',
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
      'path': os.path.join(rust_src, 'core'),
    },
    'alloc': {
      'path': os.path.join(rust_src, 'alloc'),
    },
  },
  'patch': {
    'crates-io': {
      'rustc-std-workspace-core': {
        'path': os.path.join(rust_src, 'rustc-std-workspace-core'),
      },
      'rustc-std-workspace-alloc': {
        'path': os.path.join(rust_src, 'rustc-std-workspace-alloc'),
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
