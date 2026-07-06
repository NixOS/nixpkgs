# LamBoot — Nix package derivation (prebuilt-signed -bin artifact).
#
# This repackages the published `-bin` release tarball (the Secure Boot-signed
# .efi + drivers + modules + host tooling), it does NOT build from source. The
# .efi is built on nightly Rust for x86_64-unknown-uefi and signed with private
# keys upstream; reproducing that in nixpkgs is out of scope, so we consume the
# release artifact (same stance as the apt.lamco.ai deb and the AUR -bin).
#
# Upstream version is the single source of truth in ../release.toml (0.15.2).
# Keep `version` below in sync with it; the publish/render step verifies the two
# match and fills the real `hash` before submission.
#
# Install layout mirrors the cross-channel contract in ../PACKAGING.md §3 and the
# build-validated deb (../deb/debian/rules): the whole distribution is staged
# under $out/share/lamboot (lamboot-install's SRC_DIR), the operator CLIs are
# relative symlinks into that tree, and esp-deploy.sh also lands at the literal
# /usr/lib/lamboot path the installer probes (here, $out/lib/lamboot).

{
  lib,
  stdenvNoCC,
  fetchurl,
  python3,
  efibootmgr,
  makeBinaryWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lamboot";
  version = "0.16.5"; # === ../release.toml [upstream] version; render step verifies

  src = fetchurl {
    url = "https://github.com/lamco-admin/lamboot/releases/download/v${finalAttrs.version}/lamboot-${finalAttrs.version}-x86_64.tar.gz";
    # Placeholder. The publish/render step computes the SRI hash of the
    # published artifact and stamps it here (the no-committed-checksums rule,
    # ../PACKAGING.md §4). lib.fakeHash forces a mismatch so an un-rendered
    # build fails loudly rather than silently fetching the wrong bytes.
    hash = "sha256-D/LLafnVVYRBojSI2BdpzsQ52MLoq2J1KWy9ZLmOdgI=";
  };

  # nixpkgs-vet NPV-166: every new package must set __structuredAttrs. Compatible
  # with stdenvNoCC + the shell installPhase below (build-validated on vm280).
  __structuredAttrs = true;
  # nixpkgs-vet NPV-164: new packages must set strictDeps. Safe here —
  # makeBinaryWrapper is the only native input; python3/efibootmgr are runtime.
  strictDeps = true;

  # The signed .efi is a UEFI PE binary. Stripping or ELF-patching it breaks the
  # Secure Boot signature, so disable every binary-mangling phase. autoPatchelfHook
  # is deliberately NOT in nativeBuildInputs for the same reason — there are no
  # ELF interpreters to fix up, and the .efi must be byte-identical to upstream.
  dontStrip = true;
  dontPatchELF = true;
  dontPatchShebangs = false; # host scripts (python/bash) DO want store shebangs

  # makeBinaryWrapper supplies makeWrapper for the python/efibootmgr PATH on the
  # host-tool entry points. The ESP-writing installer is wired in the NixOS
  # module, not here; see module.nix.
  nativeBuildInputs = [ makeBinaryWrapper ];

  # Runtime dependencies. lamboot-inspect and lamboot-monitor.py are python3;
  # lamboot-install shells out to efibootmgr to register the UEFI boot entry.
  # These are propagated so a `nix profile install` pulls them onto PATH, and the
  # NixOS module references them explicitly when it builds the installer's env.
  propagatedBuildInputs = [
    python3
    efibootmgr
  ];

  # No configure/build for a prebuilt payload.
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    stage="$out/share/lamboot"
    install -d "$stage"

    # 1. Stage the WHOLE distribution under $out/share/lamboot — this is
    #    lamboot-install's SRC_DIR. Exclude packaging/build metadata, man pages,
    #    completions, docs, the top-level READMEs/licenses/manifest, and python
    #    bytecode; those are installed to their own paths below (contract step 1).
    #    Top-level entries are at the tarball ROOT (no tools/ prefix).
    cp -a ./. "$stage/"
    rm -rf \
      "$stage/packaging" \
      "$stage/man" \
      "$stage/completions" \
      "$stage/docs" \
      "$stage/README.md" \
      "$stage/CHANGELOG.md" \
      "$stage/SECURITY.md" \
      "$stage/LICENSE" \
      "$stage/LICENSE-MIT" \
      "$stage/LICENSE-APACHE" \
      "$stage/MANIFEST.sha256"
    find "$stage" -type d -name __pycache__ -prune -exec rm -rf {} +
    find "$stage" -type f -name '*.pyc' -delete

    # 2. Normalise staged perms: dirs 0755, data 0644, scripts keep +x, no
    #    group/other write (matches the deb's chmod -R u=rwX,go=rX). The Nix
    #    sandbox umask is already tight, but normalise explicitly so the staged
    #    tree is identical across channels.
    chmod -R u=rwX,go=rX "$stage"

    # 3. Operator CLIs on PATH as RELATIVE symlinks into the staged tree.
    #    These MUST be symlinks, not makeWrapper wrappers: each script resolves
    #    its own realpath (lamboot-install: readlink -f "$BASH_SOURCE";
    #    lamboot-inspect: os.path.realpath(__file__)) to find siblings —
    #    esp-deploy.sh at ../lib/, the adjacent lamboot_inspect python package,
    #    sign-unlock/sign-lock next to sign-lamboot.sh. A wrapper in $out/bin
    #    would resolve realpath to $out/bin and break every sibling lookup.
    #    A relative symlink resolves through to the staged file, so realpath
    #    lands in $out/share/lamboot where the siblings live.
    install -d "$out/bin"
    ln -s ../share/lamboot/lamboot-install "$out/bin/lamboot-install"
    ln -s ../share/lamboot/lamboot-inspect "$out/bin/lamboot-inspect"
    ln -s ../share/lamboot/sign-lamboot.sh "$out/bin/lamboot-sign"

    # 4. esp-deploy.sh ALSO at the literal /usr/lib/lamboot path lamboot-install
    #    probes first (here $out/lib/lamboot). Literal lib/lamboot, never
    #    a libdir that resolves to lib64 — lamboot-install does not look there.
    #    In a Nix store the installer reaches esp-deploy.sh through the symlink's
    #    ../lib/esp-deploy.sh sibling anyway; this copy keeps the contract whole
    #    for any consumer that hard-codes the canonical path.
    install -Dm0644 "$stage/lib/esp-deploy.sh" "$out/lib/lamboot/esp-deploy.sh"

    # 5. man, bash completion, docs, licenses (per-distro convention).
    if [ -f man/man1/lamboot-inspect.1 ]; then
      install -Dm0644 man/man1/lamboot-inspect.1 \
        "$out/share/man/man1/lamboot-inspect.1"
    fi
    if [ -f completions/lamboot-inspect.bash ]; then
      install -Dm0644 completions/lamboot-inspect.bash \
        "$out/share/bash-completion/completions/lamboot-inspect"
    fi
    if [ -f completions/_lamboot-inspect ]; then
      install -Dm0644 completions/_lamboot-inspect \
        "$out/share/zsh/site-functions/_lamboot-inspect"
    fi
    if [ -d docs ]; then
      install -d "$out/share/doc/lamboot"
      cp -a docs/. "$out/share/doc/lamboot/"
    fi
    # Licenses: nixpkgs follows the Arch/rpm convention of share/licenses/<pkg>.
    install -d "$out/share/licenses/lamboot"
    for lf in LICENSE-MIT LICENSE-APACHE; do
      [ -f "$lf" ] && install -Dm0644 "$lf" "$out/share/licenses/lamboot/$lf"
    done

    runHook postInstall
  '';

  # The CLIs need python3 + efibootmgr on PATH at runtime. We cannot wrap the
  # symlinks (that would break realpath-adjacency, see step 3), so instead point
  # the python interpreter and tools through the staged scripts' own shebangs
  # (patched by dontPatchShebangs=false) and rely on propagatedBuildInputs +
  # the NixOS module's environment for efibootmgr. For the imperative
  # `nix profile` case, expose a wrapped convenience entry that adds the runtime
  # tools to PATH without disturbing the adjacency-sensitive symlinks.
  postFixup = ''
    # strictDeps splits the build/host PATH, so the default fixup's
    # `patchShebangs --host` patches the python scripts (python3 is a propagated
    # host dep) but leaves the bash scripts' `#!/bin/bash` unpatched (bash is a
    # build-time tool). Patch the whole staged tree against the build PATH so the
    # bash shebangs resolve; already-patched python shebangs (store paths) are
    # skipped. Without this, lamboot-install fails on NixOS (no /bin/bash).
    patchShebangs --build "$out/share/lamboot"
  '';

  meta = {
    description = "Memory-safe UEFI bootloader for Linux (Rust), Secure Boot-signed";
    longDescription = ''
      LamBoot is a UEFI bootloader written in Rust with a native PE loader, a
      native ext4 read backend, Boot Loader Specification multi-filesystem
      discovery, TPM measurements, and a structured trust-evidence log.

      This derivation stages the Secure Boot-signed bootloader, its filesystem
      drivers and diagnostic modules, the public signing certificate, and the
      host installer under share/lamboot. It does not write the EFI System
      Partition: lamboot-install deploys to the ESP and registers a UEFI boot
      entry. Under Secure Boot, enroll the shipped signing certificate first
      (NixOS uses Lanzaboote/sbctl, the MOK-equivalent on NixOS; see README.md).
    '';
    homepage = "https://lamco.ai/products/lamboot/";
    changelog = "https://github.com/lamco-admin/lamboot/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "lamboot-install";
    maintainers = with lib.maintainers; [ glamberson ];
  };
})
