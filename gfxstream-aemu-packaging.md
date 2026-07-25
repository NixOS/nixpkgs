# nixpkgs `gfxstream` packaging gap — guest Vulkan blocker

`nixpkgs#crosvm` is built with `buildFeatures = "virgl_renderer"` only.
The `gfxstream` cargo feature — which gives rutabaga the `gfxstream`
backend that handles the guest's `vulkan` context type — is off, so any
guest application that requests a Vulkan context fails. Bevy/wgpu falls
back to GLES via virglrenderer, which is sufficient for the game today
but is itself fragile (see [`investigations/kvm-virgl-efault.md`](./kvm-virgl-efault.md)).

Adding `gfxstream` to crosvm's cargo features pulls in pkg-config
probes against:

- `gfxstream_backend` (provided by `nixpkgs#gfxstream` 0.1.2)
- `aemu_base`, `aemu_host_common`, `aemu_snapshot`, `aemu_logging`
  (NOT packaged in nixpkgs; declared as `Requires.private` in
  `gfxstream_backend.pc`)

Without the aemu companions, `cargo build --features gfxstream` fails
at link time with `error: could not find pkg-config for "aemu_base"`.

## Why

The `aemu` libraries are part of Google's
[android-emu](https://android.googlesource.com/platform/external/qemu/)
common-shared codebase. The current nixpkgs `gfxstream` derivation
builds `libgfxstream_backend.so` against vendored copies of the aemu
sources but doesn't install separate `aemu_*` outputs or `.pc` files,
which is what rutabaga's `build.rs` `pkg_config::Config::new().probe(...)`
calls expect when `gfxstream_backend.pc` doesn't define
`GFXSTREAM_UNSTABLE`.

## Fix approaches

The fix needs to land **upstream in nixpkgs** at
`pkgs/by-name/gf/gfxstream/`. Two viable approaches:

1. **Define `GFXSTREAM_UNSTABLE` in `gfxstream_backend.pc`.** If the
   upstream gfxstream build supports a single-library mode that hides
   aemu behind `libgfxstream_backend.so` with no separate pkg-config
   probes, rutabaga's `build.rs` skips the aemu probes when
   `GFXSTREAM_UNSTABLE` is defined. Inspect the gfxstream source's
   meson/CMake options.

2. **Package aemu as siblings.** Add `aemu_base`, `aemu_host_common`,
   `aemu_snapshot`, `aemu_logging` either as separate derivations or as
   additional outputs of the gfxstream derivation, each with a working
   `.pc` file under `lib/pkgconfig/`. This matches the structure of
   gfxstream's own internal build — the libraries already exist, they
   just don't get exposed to consumers.

Either way, then update `nixpkgs#crosvm` to:

```nix
crosvm.overrideAttrs (oldAttrs: {
  cargoBuildFeatures = "virgl_renderer gfxstream";
  cargoCheckFeatures = "virgl_renderer gfxstream";
  buildInputs = oldAttrs.buildInputs ++ [ pkgs.gfxstream ];
})
```

## Where to PR

`NixOS/nixpkgs` — same target as the existing seccomp PR
[#517363](https://github.com/NixOS/nixpkgs/pull/517363). Coordinate
with `pkgs/by-name/gf/gfxstream/`'s maintainer if any.

## Validation

```
nix build nixpkgs#crosvm.override { withGfxstream = true; }  # if a flag is added
# or
nix build .#cluster-1v1-uifull-up   # uses the steampipe overlay; watch for gfxstream link
```

Then in the VM, run `vulkaninfo` after weston starts —
`RUTABAGA_CAPSET_GFXSTREAM_VULKAN` should be present in the rutabaga
capset enumeration.

## State

Open. Tracked here until `nixpkgs#crosvm` ships with `gfxstream`
cargo feature enabled by default (or behind a `withGfxstream` toggle
wired through to a working aemu setup).
