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
  python3Packages,
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
  scriptEnvPath = lib.strings.makeSearchPathOutput "out" "bin" [
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
    util-linux.bin
    which
  ];

  # Inherit attributes from a versionDefinition.
  inherit (versionDefinition)
    pname
    branch
    version
    latest
    pkg
    ;

  # Mark versions older than minSupportedVersion as EOL.
  minSupportedVersion = "4.17";

  ## Pre-fetched Source Handling ##

  # Main attribute set for sources needed to build tools and firmwares.
  # Each source takes in:
  # * A `src` attribute, which contains the actual fetcher,
  # * A 'patches` attribute, which is a list of patches that need to be applied in the source.
  # * A `path` attribute, which is the destination of the source inside the Xen tree.
  prefetchedSources =
    lib.attrsets.optionalAttrs withInternalQEMU {
      qemu = {
        src = fetchgit {
          url = "https://xenbits.xenproject.org/git-http/qemu-xen.git";
          fetchSubmodules = true;
          inherit (pkg.qemu) rev hash;
        };
        patches = lib.lists.optionals (lib.attrsets.hasAttrByPath [ "patches" ] pkg.qemu) pkg.qemu.patches;
        path = "tools/qemu-xen";
      };
    }
    // lib.attrsets.optionalAttrs withInternalSeaBIOS {
      seaBIOS = {
        src = fetchgit {
          url = "https://xenbits.xenproject.org/git-http/seabios.git";
          inherit (pkg.seaBIOS) rev hash;
        };
        patches = lib.lists.optionals (lib.attrsets.hasAttrByPath [
          "patches"
        ] pkg.seaBIOS) pkg.seaBIOS.patches;
        path = "tools/firmware/seabios-dir-remote";
      };
    }
    // lib.attrsets.optionalAttrs withInternalOVMF {
      ovmf = {
        src = fetchgit {
          url = "https://xenbits.xenproject.org/git-http/ovmf.git";
          fetchSubmodules = true;
          inherit (pkg.ovmf) rev hash;
        };
        patches = lib.lists.optionals (lib.attrsets.hasAttrByPath [ "patches" ] pkg.ovmf) pkg.ovmf.patches;
        path = "tools/firmware/ovmf-dir-remote";
      };
    }
    // lib.attrsets.optionalAttrs withInternalIPXE {
      ipxe = {
        src = fetchFromGitHub {
          owner = "ipxe";
          repo = "ipxe";
          inherit (pkg.ipxe) rev hash;
        };
        patches = lib.lists.optionals (lib.attrsets.hasAttrByPath [ "patches" ] pkg.ipxe) pkg.ipxe.patches;
        path = "tools/firmware/etherboot/ipxe.git";
      };
    };

  # Gets a list containing the names of the top-level attribute for each pre-fetched
  # source, to be used in the map functions below.
  prefetchedSourcesList = lib.attrsets.mapAttrsToList (name: value: name) prefetchedSources;

  # Produces bash commands that will copy each pre-fetched source.
  copyPrefetchedSources =
    # Finish the deployment by concatnating the list of commands together.
    lib.strings.concatLines (
      # Iterate on each pre-fetched source.
      builtins.map (
        source:
        # Only produce a copy command if patches exist.
        lib.strings.optionalString (lib.attrsets.hasAttrByPath [ "${source}" ] prefetchedSources)
          # The actual copy command. `src` is always an absolute path to a fetcher output
          # inside the /nix/store, and `path` is always a path relative to the Xen root.
          # We need to `mkdir -p` the target directory first, and `chmod +w` the contents last,
          # as the copied files will still be edited by the postPatchPhase.
          ''
            echo "Copying ${prefetchedSources.${source}.src} -> ${prefetchedSources.${source}.path}"
            mkdir --parents ${prefetchedSources.${source}.path}
            cp --recursive --no-target-directory ${prefetchedSources.${source}.src} ${
              prefetchedSources.${source}.path
            }
            chmod --recursive +w ${prefetchedSources.${source}.path}
          ''
      ) prefetchedSourcesList
    );

  # Produces strings with `patch` commands to be ran on postPatch.
  # These deploy the .patch files for each pre-fetched source.
  deployPrefetchedSourcesPatches =
    # Finish the deployment by concatnating the list of commands together.
    lib.strings.concatLines (
      # The double map functions create a list of lists. Flatten it so we can concatnate it.
      lib.lists.flatten (
        # Iterate on each pre-fetched source.
        builtins.map (
          source:
          # Iterate on each available patch.
          (builtins.map (
            patch:
            # Only produce a patch command if patches exist.
            lib.strings.optionalString
              (lib.attrsets.hasAttrByPath [
                "${source}"
                "patches"
              ] prefetchedSources)
              # The actual patch command. It changes directories to the correct source each time.
              ''
                echo "Applying patch ${patch} to ${source}."
                patch --directory ${prefetchedSources.${source}.path} --strip 1 < ${patch}
              ''
          ) prefetchedSources.${source}.patches)
        ) prefetchedSourcesList
      )
    );

  ## XSA Patches Description Builder ##

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
        throw "xen/generic/default.nix: normalisedPatchList attempted to normalise something that is not a Path or an Attribute Set."
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

  ## Binutils Override ##

  # Originally, there were two versions of binutils being used: the standard one and
  # this patched one. Unfortunately, that required patches to the Xen Makefiles, and
  # quickly became too complex to maintain. The new solution is to simply build this
  # efi-binutils derivation and use it for the whole build process, except if
  # enableEFI is disabled; it'll then use `binutils`.
  efiBinutils = binutils-unwrapped.overrideAttrs (oldAttrs: {
    name = "efi-binutils";
    configureFlags = oldAttrs.configureFlags ++ [ "--enable-targets=x86_64-pep" ];
    doInstallCheck = false; # We get a spurious failure otherwise, due to a host/target mismatch.
    meta.mainProgram = "ld"; # We only really care for `ld`.
  });
in

stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  outputs = [
    "out" # TODO: Split $out in $bin for binaries and $lib for libraries.
    "man" # Manual pages for Xen userspace utilities.
    "doc" # The full Xen documentation in HTML format.
    "dev" # Development headers.
    "boot" # xen.gz kernel, policy file if Flask is enabled, xen.efi if EFI is enabled.
    # TODO: Python package to be in separate output/package.
  ];

  # Main Xen source.
  src = fetchgit {
    url = "https://xenbits.xenproject.org/git-http/xen.git";
    inherit (pkg.xen) rev hash;
  };

  patches =
    # Generic Xen patches that apply to all Xen versions.
    [ ./0000-xen-ipxe-src-generic.patch ]
    # Gets the patches from the pkg.xen.patches attribute from the versioned files.
    ++ lib.lists.optionals (lib.attrsets.hasAttrByPath [ "patches" ] pkg.xen) pkg.xen.patches;

  nativeBuildInputs =
    [
      autoPatchelfHook
      bison
      cmake
      flex
      pandoc
      pkg-config
      python3Packages.setuptools
    ]
    ++ lib.lists.optionals withInternalQEMU [
      ninja
      python3Packages.sphinx
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
      python3Packages.python
      xz
      yajl
      zlib
      zstd

      # oxenstored
      ocamlPackages.findlib
      ocamlPackages.ocaml

      # Python Fixes
      python3Packages.wrapPython
    ]
    ++ lib.lists.optionals withInternalQEMU [
      glib
      pixman
    ]
    ++ lib.lists.optional withInternalOVMF nasm
    ++ lib.lists.optional withFlask checkpolicy
    ++ lib.lists.optional (lib.strings.versionOlder version "4.19") systemdMinimal;

  configureFlags =
    [
      "--enable-systemd"
      "--disable-qemu-traditional"
    ]
    ++ lib.lists.optional (!withInternalQEMU) "--with-system-qemu"

    ++ lib.lists.optional withSeaBIOS "--with-system-seabios=${seabios}/share/seabios"
    ++ lib.lists.optional (!withInternalSeaBIOS && !withSeaBIOS) "--disable-seabios"

    ++ lib.lists.optional withOVMF "--with-system-ovmf=${OVMF.firmware}"
    ++ lib.lists.optional withInternalOVMF "--enable-ovmf"

    ++ lib.lists.optional withIPXE "--with-system-ipxe=${ipxe}"
    ++ lib.lists.optional withInternalIPXE "--enable-ipxe"

    ++ lib.lists.optional withFlask "--enable-xsmpolicy";

  makeFlags =
    [
      "PREFIX=$(out)"
      "CONFIG_DIR=/etc"
      "XEN_SCRIPT_DIR=$(CONFIG_DIR)/xen/scripts"
      "BASH_COMPLETION_DIR=$(PREFIX)/share/bash-completion/completions"
    ]
    ++ lib.lists.optionals withEFI [
      "EFI_VENDOR=${efiVendor}"
      "INSTALL_EFI_STRIP=1"
      "LD=${lib.meta.getExe efiBinutils}" # See the comment in the efiBinutils definition above.
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

    # Call copyPrefetchedSources, which copies all aviable sources to their correct positions.
    + ''
      ${copyPrefetchedSources}
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

    # # Call deployPrefetchedSourcesPatches, which patches all pre-fetched sources with their specified patchlists.
    + ''
      ${deployPrefetchedSourcesPatches}
    ''
    # Patch shebangs for QEMU and OVMF build scripts.
    + lib.strings.optionalString withInternalQEMU ''
      patchShebangs --build tools/qemu-xen/scripts/tracetool.py
    ''
    + lib.strings.optionalString withInternalOVMF ''
      patchShebangs --build tools/firmware/ovmf-dir-remote/OvmfPkg/build.sh tools/firmware/ovmf-dir-remote/BaseTools/BinWrappers/PosixLike/{AmlToC,BrotliCompress,build,GenFfs,GenFv,GenFw,GenSec,LzmaCompress,TianoCompress,Trim,VfrCompile}
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
    '';

  postFixup =
    # Fix binaries in $out/libexec/xen/bin.
    ''
      addAutoPatchelfSearchPath $out/lib
      autoPatchelf $out/libexec/xen/bin
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

  meta =
    if
      !(lib.attrsets.hasAttrByPath [
        "meta"
      ] versionDefinition)
    then
      {
        inherit branch;

        # Short description for Xen.
        description =
          "Xen Project Hypervisor"
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
          + lib.strings.optionalString (!withInternalQEMU) (
            "\nUse with `qemu_xen_${lib.strings.stringAsChars (x: if x == "." then "_" else x) branch}`"
            + lib.strings.optionalString latest " or `qemu_xen`"
            + ".\n"
          )
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
                "\nIncludes:"
                # Originally, this was a call for the complicated withPrefetchedSources. Since there aren't
                # that many optional components, we just use lib.strings.optionalString, because it's simpler.
                # Optional components that aren't being built are automatically hidden.
                + lib.strings.optionalString withEFI "\n* `xen.efi`: The Xen Project's [EFI binary](https://xenbits.xenproject.org/docs/${branch}-testing/misc/efi.html), available on the `boot` output of this package."
                + lib.strings.optionalString withFlask "\n* `xsm-flask`: The [FLASK Xen Security Module](https://wiki.xenproject.org/wiki/Xen_Security_Modules_:_XSM-FLASK). The `xenpolicy-${version}` file is available on the `boot` output of this package."
                + lib.strings.optionalString withInternalQEMU "\n* `qemu-xen`: The Xen Project's mirror of [QEMU](https://www.qemu.org/)."
                + lib.strings.optionalString withInternalSeaBIOS "\n* `seabios-xen`: The Xen Project's mirror of [SeaBIOS](https://www.seabios.org/SeaBIOS)."
                + lib.strings.optionalString withInternalOVMF "\n* `ovmf-xen`: The Xen Project's mirror of [OVMF](https://github.com/tianocore/tianocore.github.io/wiki/OVMF)."
                + lib.strings.optionalString withInternalIPXE "\n* `ipxe-xen`: The Xen Project's pinned version of [iPXE](https://ipxe.org/)."
              )
          # Finally, we write a notice explaining which vulnerabilities this Xen is NOT vulnerable to.
          # This will hopefully give users the peace of mind that their Xen is secure, without needing
          # to search the source code for the XSA patches.
          + lib.strings.optionalString (writeAdvisoryDescription != [ ]) (
            "\n\nThis Xen Project Hypervisor (${version}) has been patched against the following known security vulnerabilities:\n"
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

        # This automatically removes maintainers from EOL versions of Xen, so we aren't bothered about versions we don't explictly support.
        maintainers = lib.lists.optionals (lib.strings.versionAtLeast version minSupportedVersion) lib.teams.xen.members;
        knownVulnerabilities = lib.lists.optional (lib.strings.versionOlder version minSupportedVersion) "The Xen Project Hypervisor version ${version} is no longer supported by the Xen Project Security Team. See https://xenbits.xenproject.org/docs/unstable/support-matrix.html";

        mainProgram = "xl";

        # Evaluates to x86_64-linux.
        platforms = lib.lists.intersectLists lib.platforms.linux lib.platforms.x86_64;

      }
    else
      versionDefinition.meta;
})
