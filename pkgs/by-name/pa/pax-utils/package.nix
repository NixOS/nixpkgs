{
  stdenv,
  lib,
  fetchgit,
  buildPackages,
  docbook_xml_dtd_44,
  docbook_xsl,
  withFuzzing ? stdenv.hostPlatform.isLinux,
  withLibcap ? stdenv.hostPlatform.isLinux,
  withSeccomp ? stdenv.hostPlatform.isLinux,
  libcap,
  pkg-config,
  meson,
  ninja,
  xmlto,
  python3,

  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pax-utils";
  version = "1.3.10";

  src = fetchgit {
    url = "https://anongit.gentoo.org/git/proj/pax-utils.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qoFXQ/RqvdjsVhXVZZjWKnE0khak9HjOGi/UrfTLS8M=";
  };

  strictDeps = true;

  mesonFlags = [
    (lib.mesonBool "use_fuzzing" withFuzzing)
    (lib.mesonEnable "use_libcap" withLibcap)
    (lib.mesonBool "use_seccomp" withSeccomp)
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    docbook_xml_dtd_44
    docbook_xsl
    meson
    ninja
    pkg-config
    xmlto
  ];
  buildInputs = lib.optionals withLibcap [ libcap ];
  # Needed for lddtree
  propagatedBuildInputs = [ (python3.withPackages (p: with p; [ pyelftools ])) ];

  passthru.updateScript = gitUpdater {
    url = "https://anongit.gentoo.org/git/proj/pax-utils.git";
    rev-prefix = "v";
  };

  meta = {
    description = "ELF utils that can check files for security relevant properties";
    longDescription = ''
      A suite of ELF tools to aid auditing systems. Contains
      various ELF related utils for ELF32, ELF64 binaries useful
      for displaying PaX and security info on a large groups of
      binary files.
    '';
    homepage = "https://wiki.gentoo.org/wiki/Hardened/PaX_Utilities";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      thoughtpolice
      joachifm
    ];
  };
})
