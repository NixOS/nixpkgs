{
  lib,
  stdenv,
  fetchgit,
  meson,
  ninja,
  pkg-config,
  fuse3,
  libevent,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "steve";
  version = "1.5.2";

  src = fetchgit {
    url = "https://anongit.gentoo.org/git/proj/steve.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a0cmia5DNFVegnH/xnA8hb0NftMV6NsQbdT3CKPHHp8=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    fuse3
    libevent
  ];

  # Upstream tests need CUSE and run in the VM test below.
  doCheck = false;

  passthru.tests.upstream = nixosTests.steve;

  meta = {
    description = "System-wide GNU Make-compatible jobserver";
    homepage = "https://gitweb.gentoo.org/proj/steve.git/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers._0xdeafbeef ];
    mainProgram = "steve";
  };
})
