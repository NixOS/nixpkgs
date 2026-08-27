{
  lib,
  stdenv,
  fetchurl,
  bash-completion,
  bison,
  cdrkit,
  cpio,
  curl,
  flex,
  getopt,
  glib,
  gnupg,
  hivex,
  jansson,
  json_c,
  libguestfs-with-appliance,
  libosinfo,
  libvirt,
  libxml2,
  makeWrapper,
  ncurses,
  ocamlPackages,
  openssl,
  pcre2,
  perlPackages,
  pkg-config,
  qemu,
  xz,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guestfs-tools";
  version = "1.54.0";

  src = fetchurl {
    url = "https://download.libguestfs.org/guestfs-tools/${lib.versions.majorMinor finalAttrs.version}-stable/guestfs-tools-${finalAttrs.version}.tar.gz";
    hash = "sha256-m27742X3r+RGSe2YO7RWSYW1I/iLQau4wrDeFZiGj6I=";
  };

  nativeBuildInputs = [
    bison
    cdrkit
    cpio
    flex
    getopt
    makeWrapper
    pkg-config
    qemu
  ]
  ++ (with perlPackages; [
    GetoptLong
    libintl-perl
    ModuleBuild
    perl
    Po4a
  ])
  ++ (with ocamlPackages; [
    findlib
    ocaml
    ounit2
  ]);

  buildInputs = [
    bash-completion
    glib
    hivex
    jansson
    json_c
    libguestfs-with-appliance
    libosinfo
    libvirt
    libxml2
    ncurses
    openssl
    pcre2
    xz
  ];

  patches = [
    # Fix build against libguestfs >= 1.58 where app2_spare1 was
    # renamed to app2_class. https://github.com/libguestfs/guestfs-tools/issues/28
    ./fix-app2-spare1.patch
  ];

  postPatch = ''
    # If it uses the executable name, then there's nothing we can do
    # when wrapping to stop it looking in
    # $out/etc/.virt-builder-wrapped, which won't exist.
    substituteInPlace common/mlstdutils/std_utils.ml \
        --replace Sys.executable_name '(Array.get Sys.argv 0)'
  '';

  preConfigure = ''
    patchShebangs ocaml-dep.sh.in ocaml-link.sh.in run.in
  '';

  makeFlags = [
    "LIBGUESTFS_PATH=${libguestfs-with-appliance}/lib/guestfs"
  ];

  installFlags = [
    "BASH_COMPLETIONS_DIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  enableParallelBuilding = true;

  # Extra arguments appended to every wrapProgram call. Overridable by
  # downstream packages (e.g. guestfs-tools-nix) to inject additional
  # PATH entries or environment variables without double-wrapping.
  extraWrapArgs = [ ];

  postInstall = ''
    wrapProgram $out/bin/virt-builder \
      --argv0 virt-builder \
      --prefix PATH : ${
        lib.makeBinPath [
          curl
          gnupg
          qemu
        ]
      }:$out/bin \
      --suffix VIRT_BUILDER_DIRS : /etc:$out/etc \
      ${lib.escapeShellArgs finalAttrs.extraWrapArgs}
    wrapProgram $out/bin/virt-win-reg \
      --prefix PATH : ${qemu}/bin \
      --prefix PERL5LIB : ${
        with perlPackages;
        makeFullPerlPath [
          hivex
          libintl-perl
          libguestfs-with-appliance
        ]
      } \
      ${lib.escapeShellArgs finalAttrs.extraWrapArgs}

    # Wrap remaining binaries so libguestfs can find qemu-img at runtime
    for f in $out/bin/virt-*; do
      case "$(basename "$f")" in
        virt-builder|virt-win-reg) continue ;;
      esac
      wrapProgram "$f" --prefix PATH : ${qemu}/bin \
        ${lib.escapeShellArgs finalAttrs.extraWrapArgs}
    done
  '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/libguestfs/guestfs-tools";
    rev-prefix = "v";
    odd-unstable = true;
  };

  meta = {
    description = "Extra tools for accessing and modifying virtual machine disk images";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    homepage = "https://libguestfs.org/";
    changelog = "https://www.libguestfs.org/guestfs-tools-release-notes-${lib.versions.majorMinor finalAttrs.version}.1.html";
    maintainers = [ ];
    platforms = lib.platforms.linux;
    hydraPlatforms = [ ];
  };
})
