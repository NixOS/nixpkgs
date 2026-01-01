{
  stdenv,
  lib,
  fetchgit,
  buildPackages,
  docbook_xml_dtd_44,
  docbook_xsl,
<<<<<<< HEAD
  withFuzzing ? stdenv.hostPlatform.isLinux,
  withLibcap ? stdenv.hostPlatform.isLinux,
  withSeccomp ? stdenv.hostPlatform.isLinux,
=======
  withLibcap ? stdenv.hostPlatform.isLinux,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  libcap,
  pkg-config,
  meson,
  ninja,
  xmlto,
  python3,

  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "pax-utils";
<<<<<<< HEAD
  version = "1.3.10";
=======
  version = "1.3.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchgit {
    url = "https://anongit.gentoo.org/git/proj/pax-utils.git";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-qoFXQ/RqvdjsVhXVZZjWKnE0khak9HjOGi/UrfTLS8M=";
=======
    hash = "sha256-fOdiZcS1ZWGN8U5v65LzGIZJD6hCl5dbLMHDpSyms+8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  strictDeps = true;

  mesonFlags = [
<<<<<<< HEAD
    (lib.mesonBool "use_fuzzing" withFuzzing)
    (lib.mesonEnable "use_libcap" withLibcap)
    (lib.mesonBool "use_seccomp" withSeccomp)
=======
    (lib.mesonEnable "use_libcap" withLibcap)
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "ELF utils that can check files for security relevant properties";
    longDescription = ''
      A suite of ELF tools to aid auditing systems. Contains
      various ELF related utils for ELF32, ELF64 binaries useful
      for displaying PaX and security info on a large groups of
      binary files.
    '';
    homepage = "https://wiki.gentoo.org/wiki/Hardened/PaX_Utilities";
<<<<<<< HEAD
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
=======
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      thoughtpolice
      joachifm
    ];
  };
}
