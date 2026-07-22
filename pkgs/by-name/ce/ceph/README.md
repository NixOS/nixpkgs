# Ceph

Ceph is a Distributed storage system providing object based (rados and S3), block based (rbd and iscsi), and filesystem based (cephfs, NFS, samba) storage.

Because Ceph is used for massive storage clusters in the wild, any changes can lead to actual data loss.
Besides having to handle changes – in particular breaking changes – somewhat carefully it also means that Ceph does move slow in terms of development.
It should be stressed here that slow release pacing is not a bad thing!

If you are looking at this page because a change in, let's say Python packaging, broke the build of *qemu_full*, then if you are not actually using Ceph for anything[^krbd] it may be easier to mask out Ceph from your build[^mask].
One common way that Ceph is being pulled in for users who do not actually use it is due to the `enableCephFS` flag of *samba4Full*.

[^krbd]: Or are only using implicit *krbd* which lives in the kernel and thus doesn't require this package.
[^mask]: You can achieve this using several ways, including an overlay setting *ceph* to *null*, or something like `qemu_full.override { cephSupport = false; }`.

## Patches

Historically Ceph often needed patches to be compatible with newer versions of *gcc*, Python, and other related software.
On occasion there may also be patches which need to be backported from the development of the current release as they may have been merged, but no new release has been made including those changes.
Because Ceph uses embedded Python interpreters in some daemons these patches need to be applied to multiple builds.
To keep drift from happening and make this more visible [the source code itself is being patched](./src.nix) before passing it on as *src* for other derivations.

## Scope

This package often requires patches, or vendored packaging so we can keep an older version of a library around specifically for Ceph.
For this reason Ceph is being maintained [within its own scope](./scope.nix), which allows us to inject such vendored packages more easily.
An example at time of writing would be *RocksDB* which is the storage format used by the Ceph storage daemons (OSDs) to store data on block devices directly.

If for whatever reason you want or need to patch Ceph, you can use the *passthru* attribute `overrideScope` to get access to the full Ceph scope.
For instance an overlay can be used to override dependencies as well as patches.

<details><summary>Example overlay for overriding Ceph</summary>

```nix
globalFinal: globalPrev: {
  ceph = builtins.getAttr "ceph" (
    globalPrev.ceph.overrideScope (
      final: prev: {
        # `prev.rocksdb` here is the vendored version of rocksdb
        # this means you can apply patches to the otherwise hidden packages

        ceph-src = prev.ceph-src.overrideAttrs (
          {
            patches ? [ ],
            ...
          }:
          {
            patches = patches ++ [
              # your patch goes here
              (globalFinal.fetchurl {
                # ...
              })
            ];
          }
        );
      }
    )
  );
}
```

</details>

## Python

Ceph is very intertwined with Python due to the subinterpreters.
The [*nixpkgs* Ceph PyO3 tracking issue](https://github.com/NixOS/nixpkgs/issues/380823) has some information on this and during the [*nixpkgs* Ceph 20.2.1 merge](https://github.com/NixOS/nixpkgs/pull/494583) several issues surfaced.
When using Ceph packaged via *nixpkgs* you should not run into PyO3 issues, if you do, please file a bug report.

There are two MGR modules which do attempt to load libraries incompatible with PyO3; *cephadm* and *diskprediction_local*.
*cephadm* conceptually does not work on NixOS since NixOS intentionally makes *systemd* configuration read-only.
However the *cephadm* MGR module is enabled by default, and it is not been patched to be less prone to PyO3 issues.
Similarly *diskprediction_local* will attempt to load Numpy/SciPy, leading to PyO3 errors.
These errors are not fatal, however they do render the modules unusable.
You can disable the modules using `ceph mgr module disable` to silence the errors.

