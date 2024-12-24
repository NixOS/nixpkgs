{
  stdenv,
  lib,
  fakeroot,
  fetchurl,
  libfaketime,
  replaceVars,
  ## runtime dependencies
  coreutils,
  file,
  findutils,
  gawk,
  ghostscript,
  gnugrep,
  gnused,
  libtiff,
  libxcrypt,
  openssl,
  psmisc,
  sharutils,
  util-linux,
  zlib,
  ## optional packages (using `null` disables some functionality)
  jbigkit ? null,
  lcms2 ? null, # for colored faxes
  openldap ? null,
  pam ? null,
  ## system-dependent settings that have to be hardcoded
  maxgid ? 65534, # null -> try to auto-detect (bad on linux)
  maxuid ? 65534, # null -> hardcoded value 60002
}:

let

  pname = "hylafaxplus";
  version = "7.0.9";
  hash = "sha512-3OJwM4vFC9pzPozPobFLiNNx/Qnkl8BpNNziRUpJNBDLBxjtg/eDm3GnprS2hpt7VUoV4PCsFvp1hxhNnhlUwQ==";

  configSite = replaceVars ./config.site {
    config_maxgid = lib.optionalString (maxgid != null) ''CONFIG_MAXGID=${builtins.toString maxgid}'';
    ghostscript_version = ghostscript.version;
    out = null; # "out" will be resolved in post-install.sh
    inherit coreutils ghostscript libtiff;
  };

  postPatch = replaceVars ./post-patch.sh {
    inherit configSite;
    maxuid = lib.optionalString (maxuid != null) (builtins.toString maxuid);
    faxcover_binpath = lib.makeBinPath [
      stdenv.shellPackage
      coreutils
    ];
    faxsetup_binpath = lib.makeBinPath [
      stdenv.shellPackage
      coreutils
      findutils
      gnused
      gnugrep
      gawk
    ];
  };

  postInstall = replaceVars ./post-install.sh {
    inherit fakeroot libfaketime;
  };

in

stdenv.mkDerivation {
  inherit pname version;
  src = fetchurl {
    url = "mirror://sourceforge/hylafax/hylafax-${version}.tar.gz";
    inherit hash;
  };
  patches = [
    # adjust configure check to work with libtiff > 4.1
    ./libtiff-4.patch
  ];
  # Note that `configure` (and maybe `faxsetup`) are looking
  # for a couple of standard binaries in the `PATH` and
  # hardcode their absolute paths in the new package.
  buildInputs = [
    file # for `file` command
    ghostscript
    libtiff
    libxcrypt
    openssl
    psmisc # for `fuser` command
    sharutils # for `uuencode` command
    util-linux # for `agetty` command
    zlib
    jbigkit # optional
    lcms2 # optional
    openldap # optional
    pam # optional
  ];
  # Disable parallel build, errors:
  #  *** No rule to make target '../util/libfaxutil.so.7.0.4', needed by 'faxmsg'.  Stop.
  enableParallelBuilding = false;

  postPatch = ". ${postPatch}";
  dontAddPrefix = true;
  postInstall = ". ${postInstall}";
  postInstallCheck = ". ${./post-install-check.sh}";
  meta = {
    changelog = "https://hylafax.sourceforge.io/news/${version}.php";
    description = "enterprise-class system for sending and receiving facsimiles";
    downloadPage = "https://hylafax.sourceforge.io/download.php";
    homepage = "https://hylafax.sourceforge.io";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.yarny ];
    platforms = lib.platforms.linux;
    longDescription = ''
      HylaFAX is a scalable and time-proven solution
      for sending and receiving facsimiles via modem(s).
      It is based on a client-server architecture,
      loosely comparable to CUPS:
      A client connects to a server to issue outbound jobs,
      the server then chooses a modem to
      connect to the receiving fax machine.
      The server notifies users about their
      outbound jobs as well as about inbound jobs.
      HylaFAX+ is a fork of HylaFAX that -- in general --
      contains a superset of the features of
      HylaFAX and produces releases more often.
      This package contains the client
      and the server parts of HylaFAX+.
    '';
  };
}
