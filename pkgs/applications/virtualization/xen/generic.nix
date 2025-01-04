versionDefinition:
{
  lib,
  stdenv,
  autoPatchelfHook,
  cmake,
  ninja,
  pkg-config,
  testers,
  which,

  fetchgit,
  fetchFromGitHub,

  # Xen
  acpica-tools,
  bison,
  bzip2,
  dev86,
  e2fsprogs,
  flex,
  libnl,
  libuuid,
  lzo,
  ncurses,
  ocamlPackages,
  perl,
  python311Packages,
  systemdMinimal,
  xz,
  yajl,
  zlib,
  zstd,

  # Xen Optional
  withInternalQEMU ? true,
  pixman,
  glib,

  withInternalSeaBIOS ? true,
  withSeaBIOS ? !withInternalSeaBIOS,
  seabios,

  withInternalOVMF ? true,
  withOVMF ? !withInternalOVMF,
  OVMF,
  nasm,

  withInternalIPXE ? true,
  withIPXE ? !withInternalIPXE,
  ipxe,

  withFlask ? false,
  checkpolicy,

  efiVendor ? "nixos", # Allow downstreams with custom branding to quickly override the EFI Vendor string.
  withEFI ? true,
  binutils-unwrapped,

  # Documentation
  fig2dev,
  pandoc,

  # Scripts
  bridge-utils,
  coreutils,
  diffutils,
  gawk,
  gnugrep,
  gnused,
  inetutils,
  iproute2,
  iptables,
  multipath-tools,
  nbd,
  openvswitch,
  util-linux,
  ...
}@packageDefinition:

let
  #TODO: fix paths instead.
  scriptEnvPath = lib.strings.concatMapStringsSep ":" (x: "${x}/bin") [
    bridge-utils
    coreutils
    diffutils
    gawk
    gnugrep
    gnused
    inetutils
    iproute2
    iptables
    multipath-tools
    nbd
    openvswitch
    perl
    util-linux
    which
  ];

  inherit (versionDefinition) branch;
  inherit (versionDefinition) version;
  inherit (versionDefinition) latest;
  inherit (versionDefinition) pkg;
  pname = "xen";

  # Sources needed to build tools and firmwares.
  prefetchedSources =
    lib.attrsets.optionalAttrs withInternalQEMU {
      qemu-xen = {
        src = fetchgit {
          url = "https://xenbits.xen.org/git-http/qemu-xen.git";
          fetchSubmodules = true;
          inherit (pkg.qemu) rev;
          inherit (pkg.qemu) hash;
        };
        patches = lib.lists.optionals (lib.attrsets.hasAttrByPath [ "patches" ] pkg.qemu) pkg.qemu.patches;
        postPatch = ''
          substituteInPlace scripts/tracetool.py \
            --replace-fail "/usr/bin/env python" "${python311Packages.python}/bin/python"
        '';
      };
    }
    // lib.attrsets.optionalAttrs withInternalSeaBIOS {
      "firmware/seabios-dir-remote" = {
        src = fetchgit {
          url = "https://xenbits.xen.org/git-http/seabios.git";
          inherit (pkg.seaBIOS) rev;
          inherit (pkg.seaBIOS) hash;
        };
        patches = lib.lists.optionals (lib.attrsets.hasAttrByPath [
          "patches"
        ] pkg.seaBIOS) pkg.seaBIOS.patches;
      };
    }
    // lib.attrsets.optionalAttrs withInternalOVMF {
      "firmware/ovmf-dir-remote" = {
        src = fetchgit {
          url = "https://xenbits.xen.org/git-http/ovmf.git";
          fetchSubmodules = true;
          inherit (pkg.ovmf) rev;
          inherit (pkg.ovmf) hash;
        };
        patches = lib.lists.optionals (lib.attrsets.hasAttrByPath [ "patches" ] pkg.ovmf) pkg.ovmf.patches;
        postPatch = ''
          substituteInPlace \
            OvmfPkg/build.sh BaseTools/BinWrappers/PosixLike/{AmlToC,BrotliCompress,build,GenFfs,GenFv,GenFw,GenSec,LzmaCompress,TianoCompress,Trim,VfrCompile} \
          --replace-fail "/usr/bin/env bash" ${stdenv.shell}
        '';
      };
    }
    // lib.attrsets.optionalAttrs withInternalIPXE {
      "firmware/etherboot/ipxe.git" = {
        src = fetchFromGitHub {
          owner = "ipxe";
          repo = "ipxe";
          inherit (pkg.ipxe) rev;
          inherit (pkg.ipxe) hash;
        };
        patches = lib.lists.optionals (lib.attrsets.hasAttrByPath [ "patches" ] pkg.ipxe) pkg.ipxe.patches;
      };
    };
  withPrefetchedSources =
    sourcePkg: lib.strings.concatLines (lib.attrsets.mapAttrsToList sourcePkg prefetchedSources);

  # Sometimes patches are sourced through a path, like ./0000-xen.patch.
  # This would break the patch attribute parser functions, so we normalise
  # all patches sourced through paths by setting them to a { type = "path"; }
  # attribute set.
  # Patches from fetchpatch are already attribute sets.
  normalisedPatchList = builtins.map (
    patch:
    if !builtins.isAttrs patch then
      if builtins.isPath patch then
        { type = "path"; }
      else
        throw "xen/generic.nix: normalisedPatchList attempted to normalise something that is not a Path or an Attribute Set."
    else
      patch
  ) pkg.xen.patches;

  # Simple counter for the number of attrsets (patches) in the patches list after normalisation.
  numberOfPatches = lib.lists.count (patch: builtins.isAttrs patch) normalisedPatchList;

  # builtins.elemAt's index begins at 0, so we subtract 1 from the number of patches in order to
  # produce the range that will be used in the following builtin.map calls.
  availablePatchesToTry = lib.lists.range 0 (numberOfPatches - 1);

  # Takes in an attrByPath input, and outputs the attribute value for each patch in a list.
  # If a patch does not have a given attribute, returns `null`. Use lib.lists.remove null
  # to remove these junk values, if necessary.
  retrievePatchAttributes =
    attributeName:
    builtins.map (
      x: lib.attrsets.attrByPath attributeName null (builtins.elemAt normalisedPatchList x)
    ) availablePatchesToTry;

  # Produces a list of newline-separated strings that lists the vulnerabilities this
  # Xen is NOT affected by, due to the applied Xen Security Advisory patches. This is
  # then used in meta.longDescription, to let users know their Xen is patched against
  # known vulnerabilities, as the package version isn't always the best indicator.
  #
  # Produces something like this: (one string for each XSA)
  #  * [Xen Security Advisory #1](https://xenbits.xenproject.org/xsa/advisory-1.html): **Title for XSA.**
  #  >Description of issue in XSA
  #Extra lines
  #are not indented,
  #but markdown should be
  #fine with it.
  #  Fixes:
  #  * [CVE-1999-00001](https://www.cve.org/CVERecord?id=CVE-1999-00001)
  #  * [CVE-1999-00002](https://www.cve.org/CVERecord?id=CVE-1999-00002)
  #  * [CVE-1999-00003](https://www.cve.org/CVERecord?id=CVE-1999-00003)
  writeAdvisoryDescription =
    if (lib.lists.remove null (retrievePatchAttributes [ "xsa" ]) != [ ]) then
      lib.lists.zipListsWith (a: b: a + b)
        (lib.lists.zipListsWith (a: b: a + "**" + b + ".**\n  >")
          (lib.lists.zipListsWith (a: b: "* [Xen Security Advisory #" + a + "](" + b + "): ")
            (lib.lists.remove null (retrievePatchAttributes [ "xsa" ]))
            (
              lib.lists.remove null (retrievePatchAttributes [
                "meta"
                "homepage"
              ])
            )
          )
          (
            lib.lists.remove null (retrievePatchAttributes [
              "meta"
              "description"
            ])
          )
        )
        (
          lib.lists.remove null (retrievePatchAttributes [
            "meta"
            "longDescription"
          ])
        )
    else
      [ ];

  withTools =
    attr: file:
    withPrefetchedSources (
      name: source:
      lib.strings.optionalString (builtins.hasAttr attr source) ''
        echo "processing ${name}"
        __do() {
          cd "tools/${name}"
          ${file name source}
        }
        ( __do )
      ''
    );

  # Originally, there were two versions of binutils being used: the standard one and
  # this patched one. Unfortunately, that required patches to the Xen Makefiles, and
  # quickly became too complex to maintain. The new solution is to simply build this
  # efi-binutils derivation and use it for the whole build process, except if
  # enableEFI is disabled; it'll then use `binutils`.
  efiBinutils = binutils-unwrapped.overrideAttrs (oldAttrs: {
    name = "efi-binutils";
    configureFlags = oldAttrs.configureFlags ++ [ "--enable-targets=x86_64-pep" ];
    doInstallCheck = false; # We get a spurious failure otherwise, due to a host/target mismatch.
  });
in

stdenv.mkDerivation (finalAttrs: {
  inherit pname;
  inherit version;

  outputs = [
    "out" # TODO: Split $out in $bin for binaries and $lib for libraries.
    "man" # Manual pages for Xen userspace utilities.
    "dev" # Development headers.
    "boot" # xen.gz kernel, policy file if Flask is enabled, xen.efi if EFI is enabled.
  ];

  # Main Xen source.
  src = fetchgit {
    url = "https://xenbits.xen.org/git-http/xen.git";
    inherit (pkg.xen) rev;
    inherit (pkg.xen) hash;
  };

  # Gets the patches from the pkg.xen.patches attribute from the versioned files.
  patches = lib.lists.optionals (lib.attrsets.hasAttrByPath [ "patches" ] pkg.xen) pkg.xen.patches;

  nativeBuildInputs =
    [
      autoPatchelfHook
      bison
      cmake
      fig2dev
      flex
      pandoc
      pkg-config
    ]
    ++ lib.lists.optionals withInternalQEMU [
      ninja
      python311Packages.sphinx
    ];
  buildInputs =
    [
      # Xen
      acpica-tools
      bzip2
      dev86
      e2fsprogs.dev
      libnl
      libuuid
      lzo
      ncurses
      perl
      python311Packages.python
      xz
      yajl
      zlib
      zstd

      # oxenstored
      ocamlPackages.findlib
      ocamlPackages.ocaml
      systemdMinimal

      # Python Fixes
      python311Packages.wrapPython
    ]
    ++ lib.lists.optionals withInternalQEMU [
      glib
      pixman
    ]
    ++ lib.lists.optional withInternalOVMF nasm
    ++ lib.lists.optional withFlask checkpolicy;

  configureFlags =
    [ "--enable-systemd" ]
    ++ lib.lists.optional (!withInternalQEMU) "--with-system-qemu"

    ++ lib.lists.optional withSeaBIOS "--with-system-seabios=${seabios}/share/seabios"
    ++ lib.lists.optional (!withInternalSeaBIOS && !withSeaBIOS) "--disable-seabios"

    ++ lib.lists.optional withOVMF "--with-system-ovmf=${OVMF.firmware}"
    ++ lib.lists.optional withInternalOVMF "--enable-ovmf"

    ++ lib.lists.optional withIPXE "--with-system-ipxe=${ipxe}"
    ++ lib.lists.optional withInternalIPXE "--enable-ipxe";

  makeFlags =
    [
      "PREFIX=$(out)"
      "CONFIG_DIR=/etc"
      "XEN_EXTFILES_URL=\\$(XEN_ROOT)/xen_ext_files"
      "XEN_SCRIPT_DIR=$(CONFIG_DIR)/xen/scripts"
      "BASH_COMPLETION_DIR=$(PREFIX)/share/bash-completion/completions"
    ]
    ++ lib.lists.optionals withEFI [
      "EFI_VENDOR=${efiVendor}"
      "INSTALL_EFI_STRIP=1"
      "LD=${efiBinutils}/bin/ld" # See the comment in the efiBinutils definition above.
    ]
    # These flags set the CONFIG_* options in /boot/xen.config
    # and define if the default policy file is built. However,
    # the Flask binaries always get compiled by default.
    ++ lib.lists.optionals withFlask [
      "XSM_ENABLE=y"
      "FLASK_ENABLE=y"
    ]
    ++ (pkg.xen.makeFlags or [ ]);

  buildFlags = [
    "xen" # Build the Xen Hypervisor.
    "tools" # Build the userspace tools, such as `xl`.
    "docs" # Build the Xen Documentation
    # TODO: Enable the Stubdomains target. This requires another pre-fetched source: mini-os. Currently, Xen appears to build a limited version of stubdomains which does not include mini-os.
    # "stubdom"
  ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = builtins.toString (
    [
      "-Wno-error=maybe-uninitialized"
      "-Wno-error=array-bounds"
    ]
    ++ lib.lists.optionals withInternalOVMF [
      "-Wno-error=format-security"
      "-Wno-error=use-after-free"
      "-Wno-error=vla-parameter"
      "-Wno-error=dangling-pointer"
      "-Wno-error=stringop-overflow"
    ]
  );

  dontUseCmakeConfigure = true;
  dontUseNinjaBuild = withInternalQEMU;

  prePatch =
    # Xen's stubdoms, tools and firmwares need various sources that
    # are usually fetched at build time using wget and git. We can't
    # have that, so we pre-fetch them in the versioned Nix expressions,
    # and produce fake wget and git executables for debugging purposes.
    #
    # We also produce a fake hostname executable to prevent spurious
    # command-not-found errors during compilation.
    #
    # The snippet below produces executables that simply print in stdout
    # what they were supposed to fetch, and exit gracefully.
    ''
      mkdir fake-bin

      cat > fake-bin/wget << EOF
      #!${stdenv.shell} -e
      echo ===== FAKE WGET: Not fetching \$*
      [ -e \$3 ]
      EOF

      cat > fake-bin/git << EOF
      #!${stdenv.shell}
      echo ===== FAKE GIT: Not cloning \$*
      [ -e \$3 ]
      EOF

      cat > fake-bin/hostname << EOF
      #!${stdenv.shell}
      echo ${efiVendor}
      [ -e \$3 ]
      EOF

      chmod +x fake-bin/*
      export PATH=$PATH:$PWD/fake-bin
    ''

    # Remove in-tree QEMU sources, as we either pre-fetch them through
    # the versioned Nix expressions if withInternalQEMU is true, or we
    # don't build QEMU at all if withInternalQEMU is false.
    + ''
      rm --recursive --force tools/qemu-xen tools/qemu-xen-traditional
    ''

    # The following expression moves the sources we fetched in the
    # versioned Nix expressions to their correct locations inside
    # the Xen source tree.
    + ''
      ${withPrefetchedSources (
        name: source: ''
          echo "Copying pre-fetched source: ${source.src} -> tools/${name}"
          cp --recursive ${source.src} tools/${name}
          chmod --recursive +w tools/${name}
        ''
      )}
    '';

  postPatch =
    # The following patch forces Xen to install xen.efi on $out/boot
    # instead of $out/boot/efi/efi/nixos, as the latter directory
    # would otherwise need to be created manually. This also creates
    # a more consistent output for downstreams who override the
    # efiVendor attribute above.
    ''
      substituteInPlace xen/Makefile \
        --replace-fail "\$(D)\$(EFI_MOUNTPOINT)/efi/\$(EFI_VENDOR)/\$(T)-\$(XEN_FULLVERSION).efi" \
                  "\$(D)\$(BOOT_DIR)/\$(T)-\$(XEN_FULLVERSION).efi"
    ''

    # The following patch fixes the call to /bin/mkdir on the
    # launch_xenstore.sh helper script.
    + ''
      substituteInPlace tools/hotplug/Linux/launch-xenstore.in \
        --replace-fail "/bin/mkdir" "${coreutils}/bin/mkdir"
    ''

    # The following expression fixes the paths called by Xen's systemd
    # units, so we can use them in the NixOS module.
    + ''
      substituteInPlace \
        tools/hotplug/Linux/systemd/{xen-init-dom0,xen-qemu-dom0-disk-backend,xenconsoled,xendomains,xenstored}.service.in \
        --replace-fail /bin/grep ${gnugrep}/bin/grep
      substituteInPlace \
       tools/hotplug/Linux/systemd/{xen-qemu-dom0-disk-backend,xenconsoled}.service.in \
        --replace-fail "/bin/mkdir" "${coreutils}/bin/mkdir"
    ''

    # The following expression applies the patches defined on each
    # prefetchedSources attribute.
    + ''
      ${withTools "patches" (
        name: source: ''
          ${lib.strings.concatMapStringsSep "\n" (patch: ''
            echo "Patching with ${patch}"
            patch --strip 1 < ${patch}
          '') source.patches}
        ''
      )}

           ${withTools "postPatch" (name: source: source.postPatch)}

           ${pkg.xen.postPatch or ""}
    '';

  preBuild = lib.lists.optionals (lib.attrsets.hasAttrByPath [ "preBuild" ] pkg.xen) pkg.xen.preBuild;

  postBuild = ''
    ${withTools "buildPhase" (name: source: source.buildPhase)}

    ${pkg.xen.postBuild or ""}
  '';

  installPhase =
    let
      cpFlags = builtins.toString [
        "--preserve=mode,ownership,timestamps,link"
        "--recursive"
        "--verbose"
        "--no-dereference"
      ];
    in
    # Run the preInstall tasks.
    ''
      runHook preInstall
    ''

    # Create $out directories and copy build output.
    + ''
      mkdir --parents $out $out/share $boot
      cp ${cpFlags} dist/install/nix/store/*/* $out/
      cp ${cpFlags} dist/install/etc $out
      cp ${cpFlags} dist/install/boot $boot
    ''

    # Run the postInstall tasks.
    + ''
      runHook postInstall
    '';

  postInstall =
    # Wrap xencov_split, xenmon and xentrace_format.
    ''
      wrapPythonPrograms
    ''

    # We also need to wrap pygrub, which lies in $out/libexec/xen/bin.
    + ''
      wrapPythonProgramsIn "$out/libexec/xen/bin" "$out $pythonPath"
    ''

    # Fix shebangs in Xen's various scripts.
    #TODO: Remove any and all usage of `sed` and replace these complicated magic runes with readable code.
    + ''
      shopt -s extglob
      for i in $out/etc/xen/scripts/!(*.sh); do
        sed --in-place "2s@^@export PATH=$out/bin:${scriptEnvPath}\n@" $i
      done
    ''

    + ''
      ${withTools "installPhase" (name: source: source.installPhase)}

      ${pkg.xen.installPhase or ""}
    '';

  postFixup =
    # Fix binaries in $out/lib/xen/bin.
    ''
      addAutoPatchelfSearchPath $out/lib
      autoPatchelf $out/libexec/xen/bin/
    ''
    # Flask is particularly hard to disable. Even after
    # setting the make flags to `n`, it still gets compiled.
    # If withFlask is disabled, delete the extra binaries.
    + lib.strings.optionalString (!withFlask) ''
      rm -f $out/bin/flask-*
    '';

  passthru = {
    efi =
      if withEFI then "boot/xen-${version}.efi" else throw "This Xen was compiled without an EFI binary.";
    flaskPolicy =
      if withFlask then
        "boot/xenpolicy-${version}"
      else
        throw "This Xen was compiled without FLASK support.";
    qemu-system-i386 =
      if withInternalQEMU then
        "libexec/xen/bin/qemu-system-i386"
      else
        throw "This Xen was compiled without a built-in QEMU.";
    # This test suite is very simple, as Xen's userspace
    # utilities require the hypervisor to be booted.
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
        moduleNames = [
          "xencall"
          "xencontrol"
          "xendevicemodel"
          "xenevtchn"
          "xenforeignmemory"
          "xengnttab"
          "xenguest"
          "xenhypfs"
          "xenlight"
          "xenstat"
          "xenstore"
          "xentoolcore"
          "xentoollog"
          "xenvchan"
          "xlutil"
        ];
      };
    };
  };

  meta = {
    inherit branch;
    # Short description for Xen.
    description =
      "Xen Hypervisor"
      # The "and related components" addition is automatically hidden if said components aren't being built.
      + lib.strings.optionalString (prefetchedSources != { }) " and related components"
      # To alter the description inside the paranthesis, edit ./packages.nix.
      + lib.strings.optionalString (lib.attrsets.hasAttrByPath [
        "meta"
        "description"
      ] packageDefinition) " (${packageDefinition.meta.description})";
    # Long description for Xen.
    longDescription =
      # Starts with the longDescription from ./packages.nix.
      (packageDefinition.meta.longDescription or "")
      +
        lib.strings.optionalString (!withInternalQEMU)
          "\nUse with `qemu_xen_${lib.stringAsChars (x: if x == "." then "_" else x) branch}`"
      + lib.strings.optionalString latest "or `qemu_xen`"
      + "."
      # Then, if any of the optional with* components are being built, add the "Includes:" string.
      +
        lib.strings.optionalString
          (
            withInternalQEMU
            || withInternalSeaBIOS
            || withInternalOVMF
            || withInternalIPXE
            || withEFI
            || withFlask
          )
          (
            "\nIncludes:\n"
            # Originally, this was a call for the complicated withPrefetchedSources. Since there aren't
            # that many optional components, we just use lib.strings.optionalString, because it's simpler.
            # Optional components that aren't being built are automatically hidden.
            + lib.strings.optionalString withEFI "* `xen.efi`: Xen's [EFI binary](https://xenbits.xenproject.org/docs/${branch}-testing/misc/efi.html), available on the `boot` output of this package.\n"
            + lib.strings.optionalString withFlask "* `xsm-flask`: The [FLASK Xen Security Module](https://wiki.xenproject.org/wiki/Xen_Security_Modules_:_XSM-FLASK). The `xenpolicy-${version}` file is available on the `boot` output of this package.\n"
            + lib.strings.optionalString withInternalQEMU "* `qemu-xen`: Xen's mirror of [QEMU](https://www.qemu.org/).\n"
            + lib.strings.optionalString withInternalSeaBIOS "* `seabios-xen`: Xen's mirror of [SeaBIOS](https://www.seabios.org/SeaBIOS).\n"
            + lib.strings.optionalString withInternalOVMF "* `ovmf-xen`: Xen's mirror of [OVMF](https://github.com/tianocore/tianocore.github.io/wiki/OVMF).\n"
            + lib.strings.optionalString withInternalIPXE "* `ipxe-xen`: Xen's pinned version of [iPXE](https://ipxe.org/).\n"
          )
      # Finally, we write a notice explaining which vulnerabilities this Xen is NOT vulnerable to.
      # This will hopefully give users the peace of mind that their Xen is secure, without needing
      # to search the source code for the XSA patches.
      + lib.strings.optionalString (writeAdvisoryDescription != [ ]) (
        "\nThis Xen (${version}) has been patched against the following known security vulnerabilities:\n"
        + lib.strings.removeSuffix "\n" (lib.strings.concatLines writeAdvisoryDescription)
      );
    homepage = "https://xenproject.org/";
    downloadPage = "https://downloads.xenproject.org/release/xen/${version}/";
    changelog = "https://wiki.xenproject.org/wiki/Xen_Project_${branch}_Release_Notes";
    license = with lib.licenses; [
      # Documentation.
      cc-by-40
      # Most of Xen is licensed under the GPL v2.0.
      gpl2Only
      # Xen Libraries and the `xl` command-line utility.
      lgpl21Only
      # Development headers in $dev/include.
      mit
    ];
    maintainers = [ lib.maintainers.sigmasquadron ];
    mainProgram = "xl";
    # Evaluates to x86_64-linux.
    platforms = lib.lists.intersectLists lib.platforms.linux lib.platforms.x86_64;
    knownVulnerabilities = lib.lists.optionals (lib.strings.versionOlder version "4.16") [
      "Xen ${version} is no longer supported by the Xen Security Team. See https://xenbits.xenproject.org/docs/unstable/support-matrix.html"
    ];
  };
})
