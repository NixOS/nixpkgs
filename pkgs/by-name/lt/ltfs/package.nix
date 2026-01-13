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
  version = "2.4.8.2-10520";

  src = fetchFromGitHub {
    owner = "LinearTapeFileSystem";
    repo = "ltfs";
    tag = "v${finalattrs.version}";
    hash = "sha256-1+oJyv5FrKc1GkPhARkv+w7CDrW1M8LKRK5Rb6pej5I=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    autoreconfHook
    libtool
    net-snmp
    pkg-config
  ];

  buildInputs = [
    fuse
    icu66
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
