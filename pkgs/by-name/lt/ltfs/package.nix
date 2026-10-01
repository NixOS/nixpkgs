{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  autoconf,
  automake,
  autoreconfHook,
  fuse,
  icu66,
  libtool,
  libxml2,
  libuuid,
  net-snmp,
  pkg-config,
  python3,
}:
stdenv.mkDerivation (finalattrs: {
  pname = "ltfs";
  version = "2.4.8.3-10521";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "LinearTapeFileSystem";
    repo = "ltfs";
    tag = "v${finalattrs.version}";
    hash = "sha256-O1BwzUsGtFPqpSZJqmYOVQAdYW7FBr2G61ZBimbrXMo=";
    fetchSubmodules = true;
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error=declaration-after-statement";

  nativeBuildInputs = [
    autoconf
    automake
    autoreconfHook
    icu66
    libtool
    net-snmp
    pkg-config
  ];

  buildInputs = [
    fuse
    libxml2
    libuuid
    (python3.withPackages (ps: with ps; [ xattr ]))
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Reference implementation of the LTFS format Spec for stand alone tape drive";
    homepage = "https://github.com/LinearTapeFileSystem/ltfs";
    changelog = "https://github.com/LinearTapeFileSystem/ltfs/releases/tag/v${finalattrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.amadejkastelic ];
    platforms = lib.platforms.linux;
  };
})
