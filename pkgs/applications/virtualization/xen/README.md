<p align="center">
  <a href="https://xenproject.org/">
    <picture>
      <source
        media="(prefers-color-scheme: light)"
        srcset="https://downloads.xenproject.org/Branding/Logos/Green+Black/xen_project_logo_dualcolor_2000x832.png">
      <source
        media="(prefers-color-scheme: dark)"
        srcset="https://xenproject.org/wp-content/uploads/sites/79/2018/09/logo_xenproject.png">
      <img
        src="https://downloads.xenproject.org/Branding/Logos/Green+Black/xen_project_logo_dualcolor_2000x832.png"
        width="512px"
        alt="Xen Project Logo">
    </picture>
  </a>
</p>

# Xen Hypervisor <a href="https://xenproject.org/"><img src="https://downloads.xenproject.org/Branding/Mascots/Xen-Fu-Panda-2000px.png" width="48px" align="top" alt="Xen Fu Panda"></a>

This directory includes the build recipes for the [Xen Hypervisor](https://xenproject.org/).

Some other notable packages that compose the Xen Ecosystem include:

- `ocamlPackages.xenstore`: Mirage's `oxenstore` implementation.
- `ocamlPackages.vchan`: Mirage's `xen-vchan` implementation.
- `ocamlPackages.xenstore-tool`: XAPI's `oxenstore` utilities.
- `xen-guest-agent`: Guest drivers for UNIX domUs.
- `win-pvdrivers`: Guest drivers for Windows domUs.
- `xtf`: The Xen Test Framework.

## Updating

### Automatically

An automated update script is available in this directory. To produce up-to-date
files for all supported Xen branches, simply run `./update.sh`, and follow the
instructions given to you by the script. Notably, it will request that you verify
the Xen Project code signing PGP key. This README understands that the fingerprint
of that key is [`23E3 222C 145F 4475 FA80 60A7 83FE 14C9 57E8 2BD9`](https://keys.openpgp.org/search?q=pgp%40xen.org),
but you should verify this information by seeking the fingerprint from other trusted
sources, as this document may be compromised. Once the PGP key is verified, it will
use `git verify-tag` to ascertain the validity of the cloned Xen sources.

After the script is done, follow the steps in
[**For Both Update Methods**](#for-both-update-methods) below.

#### Downstream Patch Names

The script expects local patch names to follow a certain specification.
Please name any required patches using the template below:

```console
0000-project-description-branch.patch
```

Where:

1. The first four numbers define the patch order.
   **0001** will be applied after **0000**, and so on.
1. `project` means the name of the source the patch should be applied to.
   - If you are applying patches to the main Xen sources, use `xen`.
   - For the pre-fetched QEMU, use `qemu`.
   - For SeaBIOS, use `seabios`.
   - For OVMF, use `ovmf`.
   - For iPXE, use `ipxe`.
1. `description` is a string with uppercase and lowercase letters, numbers and
   dashes. It describes the patch name and what it does to the upstream code.
1. `branch` is the branch for which this patch is supposed to patch.
   It should match the name of the directory it is in.

For example, a patch fixing `xentop`'s output in the 4.15 branch should have
the following name: `0000-xen-xentop-output-4.15.patch`, and it should be added
to the `4.15/` directory.

### Manually

The script is not infallible, and it may break in the future. If that happens,
open a PR fixing the script, and update Xen manually:

1. Check the support matrix to see which branches are security-supported.
1. Create one directory per branch.
1. [Update](https://xenbits.xenproject.org/gitweb/) the `default.nix` files for
   the branches that already exist and copy a new one to any branches that do
   not yet exist in Nixpkgs.
   - Do not forget to set the `branch`, `version`, and `latest` attributes for
     each of the `default.nix` files.
   - The revisions are preferably commit hashes, but tag names are acceptable
     as well.

### For Both Update Methods

1. Update `packages.nix` and `../../../top-level/all-packages.nix` with the new
   versions. Don't forget the `slim` packages!
1. Make sure all branches build. (Both the `standard` and `slim` versions)
1. Use the NixOS module to test if dom0 boots successfully on all new versions.
1. Make sure the `meta` attributes evaluate to something that makes sense. The
   following one-line command is useful for testing this:

   ```console
   xenToEvaluate=xen; echo -e "\033[1m$(nix eval .#"$xenToEvaluate".meta.description --raw 2> /dev/null)\033[0m\n\n$(nix eval .#"$xenToEvaluate".meta.longDescription --raw 2> /dev/null)"
   ```

   Change the value of `xenToEvaluate` to evaluate all relevant Xen packages.
1. Run `xtf --all --host` as root when booted into the Xen update, and make
   sure no tests fail.
1. Clean up your changes and commit them, making sure to follow the
   [Nixpkgs Contribution Guidelines](../../../../CONTRIBUTING.md).
1. Open a PR and await a review from the current maintainers.

## Features

### Pre-fetched Sources

On a typical Xen build, the Xen Makefiles will fetch more required sources with
`git` and `wget`. Due to the Nix Sandbox, build-time fetching will fail, so we
pre-fetch the required sources before building.[^1] To accomplish this, we have
a `prefetchedSources` attribute that contains the required derivations, if they
are requested by the main Xen build.

### EFI

Building `xen.efi` requires an `ld` with PE support.[^2]

We use a `makeFlag` to override the `$LD` environment variable to point to our
patched `efiBinutils`. For more information, see the comment in `./generic/default.nix`.

> [!TIP]
> If you are certain you will not be running Xen in an x86 EFI environment, disable
the `withEFI` flag with an [override](https://nixos.org/manual/nixpkgs/stable/#chap-overrides)
to save you the need to compile `efiBinutils`.

### Default Overrides

By default, Xen also builds
[QEMU](https://www.qemu.org/),
[SeaBIOS](https://www.seabios.org/SeaBIOS),
[OVMF](https://github.com/tianocore/tianocore.github.io/wiki/OVMF) and
[iPXE](https://ipxe.org/).

- QEMU is used for stubdomains and handling devices.
- SeaBIOS is the default legacy BIOS ROM for HVM domains.
- OVMF is the default UEFI ROM for HVM domains.
- iPXE provides a PXE boot environment for HVMs.

However, those packages are already available on Nixpkgs, and Xen does not
necessarily need to build them into the main hypervisor build. For this reason,
we also have the `withInternal<Component>` flags, which enables and disables
building those built-in components. The two most popular Xen configurations will
be the default build, with all built-in components, and a `slim` build, with none
of those components. To simplify this process, the `./packages.nix` file includes
the `xen-slim` package overrides that have all `withInternal<Component>` flags
disabled. See the `meta.longDescription` attribute for the `xen-slim` packages
for more information.

## Security

We aim to support all **security-supported** versions of Xen at any given time.
See the [Xen Support Matrix](https://xenbits.xen.org/docs/unstable/support-matrix.html)
for a list of versions. As soon as a version is no longer **security-supported**,
it should be removed from Nixpkgs.

> [!CAUTION]
> Pull requests that introduce XSA patches
should have the `1.severity: security` label.

### Maintainers

Xen is a particularly complex piece of software, so we are always looking for new
maintainers. Help out by [making and triaging issues](https://github.com/NixOS/nixpkgs/issues/new/choose),
[sending build fixes and improvements through PRs](https://github.com/NixOS/nixpkgs/compare),
updating the branches, and [patching security flaws](https://xenbits.xenproject.org/xsa/).

We are also looking for testers, particularly those who can test Xen on AArch64
machines. Open issues for any build failures or runtime errors you find!

## Tests

So far, we only have had one simple automated test that checks for
the correct `pkg-config` output files.

Due to Xen's nature as a type-1 hypervisor, it is not a trivial matter to design
new tests, as even basic functionality requires a machine booted in a dom0
kernel. For this reason, most testing done with this package must be done
manually in a NixOS machine with `virtualisation.xen.enable` set to `true`.

Another unfortunate thing is that none of the Xen commands have a `--version`
flag. This means that `testers.testVersion` cannot ascertain the Xen version.
The only way to verify that you have indeed built the correct version is to
boot into the freshly built Xen kernel and run `xl info`.

<p align="center">
  <a href="https://xenproject.org/">
    <img
      src="https://downloads.xenproject.org/Branding/Mascots/Xen%20Big%20Panda%204242x3129.png"
      width="96px"
      alt="Xen Fu Panda">
  </a>
</p>

[^1]: We also produce fake `git`, `wget` and `hostname` binaries that do nothing,
      to prevent the build from failing because Xen cannot fetch the sources that
      were already fetched by Nix.
[^2]: From the [Xen Documentation](https://xenbits.xenproject.org/docs/unstable/misc/efi.html):
      > For x86, building `xen.efi` requires `gcc` 4.5.x or above (4.6.x or newer
      recommended, as 4.5.x was probably never really tested for this purpose)
      and `binutils` 2.22 or newer. Additionally, the `binutils` build must be
      configured to include support for the x86_64-pep emulation (i.e.
      `--enable-targets=x86_64-pep` or an option of equivalent effect should be
      passed to the configure script).
