{
  lib,
  python3Packages,
  fetchFromGitHub,
  stdenv,
  systemd,
  pandoc,
  kmod,
  gnutar,
  util-linux,
  cpio,
  bash,
  coreutils,
  btrfs-progs,
  libseccomp,
  replaceVars,
  udevCheckHook,

  # Optional dependencies
  withQemu ? false,
  qemu,
}:
let
  # For systemd features used by mkosi, see
  # https://github.com/systemd/mkosi/blob/19bb5e274d9a9c23891905c4bcbb8f68955a701d/action.yaml#L64-L72
  systemdForMkosi =
    (systemd.override {
      withRepart = true;
      withBootloader = true;
      withSysusers = true;
      withFirstboot = true;
      withEfi = true;
      withUkify = true;
      withKernelInstall = true;
    }).overrideAttrs
      (prevAttrs: {
        # Use the default PATH instead of the nix store path
        postPatch = (prevAttrs.postPatch or "") + ''
          substituteInPlace src/basic/path-util.h \
            --replace-fail "\"$out/bin/\"" \
            '"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"'
        '';

        # Use the FHS nologin path, not the nix store path
        mesonFlags = (prevAttrs.mesonFlags or [ ]) ++ [
          (lib.mesonOption "nologin-path" "/usr/sbin/nologin")
        ];
      });

  pythonWithPefile = python3Packages.python.withPackages (ps: [ ps.pefile ]);

  deps = [
    bash
    btrfs-progs
    coreutils
    cpio
    gnutar
    kmod
    systemdForMkosi
    util-linux
  ]
  ++ lib.optionals withQemu [
    qemu
  ];
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mkosi";
  version = "27";
  pyproject = true;

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "mkosi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uUNPGFXrwTiSC6/EcYIxbAizjcS3Hqe1LABa5BmWGgw=";
  };

  patches = [
    (replaceVars ./0001-Use-wrapped-binaries-instead-of-Python-interpreter.patch {
      UKIFY = "${systemdForMkosi}/lib/systemd/ukify";
      PYTHON_PEFILE = lib.getExe pythonWithPefile;
      NIX_PATH = toString (lib.makeBinPath deps);
      MKOSI_SANDBOX = null; # will be replaced in postPatch
    })
    (replaceVars ./0002-Fix-library-resolving.patch {
      LIBC = "${stdenv.cc.libc}/lib/libc.so.6";
      LIBSECCOMP = "${libseccomp.lib}/lib/libseccomp.so.2";
    })
  ]
  ++ lib.optional withQemu (
    replaceVars ./0003-Fix-QEMU-firmware-path.patch {
      QEMU_FIRMWARE = "${qemu}/share/qemu/firmware";
    }
  );

  postPatch = ''
    # As we need the $out reference, we can't use `replaceVars` here.
    substituteInPlace mkosi/{run,__init__}.py \
      --replace-fail '@MKOSI_SANDBOX@' "$out/bin/mkosi-sandbox"
  '';

  nativeBuildInputs = [
    pandoc
    python3Packages.setuptools
    python3Packages.setuptools-scm
    python3Packages.wheel
    udevCheckHook
  ];

  dependencies = deps;

  postBuild = ''
    ./tools/make-man-page.sh
  '';

  checkInputs = [
    python3Packages.pytestCheckHook
  ];

  postInstall = ''
    mkdir -p $out/share/man/man1
    mv mkosi/resources/man/mkosi.1 $out/share/man/man1/
  '';

  # Workaround for https://github.com/NixOS/nixpkgs/issues/510068
  postFixup = ''
    rm -f "$out/bin/mkosi-sandbox" "$out/bin/.mkosi-sandbox-wrapped"
    sed "1i#!${python3Packages.python.interpreter} -SI" \
      "$out/${python3Packages.python.sitePackages}/mkosi/sandbox.py" \
      > "$out/bin/mkosi-sandbox"
    chmod +x "$out/bin/mkosi-sandbox"
  '';

  meta = {
    description = "Build legacy-free OS images";
    homepage = "https://github.com/systemd/mkosi";
    changelog = "https://github.com/systemd/mkosi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl21Only;
    mainProgram = "mkosi";
    maintainers = with lib.maintainers; [
      malt3
      msanft
    ];
    platforms = lib.platforms.linux;
  };
})
