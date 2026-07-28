{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  # Configurable options
  buildProduct ? # can be "client" or "daemon"
    if buildClient != null then
      lib.warn ''
        buildClient is deprecated;
        use buildProduct instead
      '' (if buildClient then "client" else "daemon")
    else
      "client",
  # Deprecated options
  # Remove them before next version of either Nixpkgs or bsd-finger itself
  buildClient ? null,
}:

assert lib.elem buildProduct [
  "client"
  "daemon"
];
stdenv.mkDerivation (finalAttrs: {
  pname = "bsd-finger" + lib.optionalString (buildProduct == "daemon") "d";
  version = "0.17";

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/b/bsd-finger/bsd-finger_${finalAttrs.version}.orig.tar.bz2";
    hash = "sha256-KLNNYF0j6mh9eeD8SMA1q+gPiNnBVH56pGeW0QgcA2M=";
  };

  patches =
    let
      debianRevision = "17";
      generateUrl =
        patchName:
        "https://sources.debian.org/data/main/b/bsd-finger/${finalAttrs.version}-${debianRevision}/debian/patches/${patchName}.patch";
    in
    [
      # Patches original finger sources to make the programs more robust and
      # compatible
      (fetchpatch {
        url = generateUrl "01-legacy";
        hash = "sha256-84znJLXez4w6WB2nOW+PHK/0srE0iG9nGAjO1/AGczw=";
      })

      # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=518559
      #
      # Doesn't work with a non-iterable nsswitch source
      #
      # Currently, "finger tabbott" works by iterating through the list of users
      # on the system using getpwent and checking if any of them match
      # "tabbott".
      #
      # Some nsswitch backends (including Hesiod and LDAP[1]) do not support
      # iterating through the complete list of users.  These nsswitch backends
      # instead only fully support looking up a user's information by username
      # or uid.
      #
      # So, if tabbott is a user whose nsswitch information comes from LDAP,
      # then "finger tabbott" will incorrectly report "finger: tabbott: no such
      # user."  "finger -m tabbott" does work correctly, however, because it
      # looks up the matching username using getpwnam.
      #
      # A fix for this is to always look up an argument to finger for a username
      # match, and having -m only control whether finger searches the entire
      # user database for real name matches.  Patch attached.
      #
      # This patch has the advantageous side effect that if there are some real
      # name matches and a username match, finger will always display the
      # username match first (rather than in some random place in the list).
      #
      #     -Tim Abbott
      #
      # [1] with LDAP, it is typically the case that one can iterate through
      # only the first 100 results from a query.
      (fetchpatch {
        url = generateUrl "02-518559-nsswitch-sources";
        hash = "sha256-oBXJ/kr/czevWk0TcsutGINNwCoHnEStRT8Jfgp/lbM=";
      })

      # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=468454
      # Implement IPv6 capacity for the server Fingerd.
      (fetchpatch {
        url = generateUrl "03-468454-fingerd-ipv6";
        hash = "sha256-a5+qoy2UKa2nCJrwrfJ5VPZoACFXFQ1j/rweoMYW1Z0=";
      })

      # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=468454
      # Implement IPv6 capability for the client Finger.
      (fetchpatch {
        url = generateUrl "04-468454-finger-ipv6";
        hash = "sha256-cg93NL02lJm/5Freegb3EbjDAQVkurLEEJifcyQRRfk=";
      })

      # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=547014
      # From: "Matthew A. Dunford" <mdunford@lbl.gov>
      #
      # finger segfaults when it comes across a netgroup entry in /etc/passwd.
      # A netgroup entry doesn't include many of the fields in a normal passwd
      # entry, so pw->pw_gecos is set to NULL, which causes finger to core dump.
      #
      # Here is part of a /etc/passwd file with a netgroup entry:
      #
      # nobody:x:65534:65534:nobody:/nonexistent:/bin/sh +@operator
      #
      # This patch sidesteps what finger considers a malformed passwd entry:
      (fetchpatch {
        url = generateUrl "05-547014-netgroup";
        hash = "sha256-d+ufp7nPZwW+t+EWASzHrXT/O6zSzt6OOV12cKVo3P0=";
      })

      # Decrease timeout length during connect().
      # In cases where a name server is answering with A as well as AAAA
      # records, but the system to be queried has lost a corresponding address,
      # the TCP handshake timeout will cause a long delay before allowing the
      # query of the next address family, or the next address in general.
      #  .
      # The use of a trivial signal handler for SIGALRM allows the reduction of
      # this timeout, thus producing better responsiveness for the interactive
      # user of the Finger service.
      # Author: Mats Erik Andersson <debian@gisladisker.se>
      (fetchpatch {
        url = generateUrl "06-572211-decrease-timeout";
        hash = "sha256-KtNGU5mmX1nnxQc7XnYoUuVW4We2cF81+x6EQrHF7g0=";
      })

      # Use cmake as build system
      (fetchpatch {
        url = generateUrl "use-cmake-as-buildsystem";
        hash = "sha256-YOmkF6Oxowy15mCE1pCvHKnLEXglijWFG6eydnZJFhM=";
      })

      # Debian-specific changes to the cmake build system (that NixOS will also
      # benefit from)
      # Adds -D_GNU_SOURCE, which will enable many C extensions that finger
      # benefits from
      (fetchpatch {
        url = generateUrl "use-cmake-as-buildsystem-debian-extras";
        hash = "sha256-T3DWpyyz15JCiVJ41RrJEhsmicei8G3OaKpxvzOCcBU=";
      })

      # Fix typo at fingerd man page (Josue Ortega <josue@debian.org>)
      (fetchpatch {
        url = generateUrl "fix-fingerd-man-typo";
        hash = "sha256-f59osGi0a8Tkm2Vxg2+H2brH8WproCDvbPf4jXwi6ag=";
      })
    ];

  env.NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  preBuild =
    let
      subdir =
        {
          "client" = "finger";
          "daemon" = "fingerd";
        }
        .${buildProduct};
    in
    ''
      cd ${subdir}
    '';

  preInstall =
    let
      bindir =
        {
          "client" = "bin";
          "daemon" = "sbin";
        }
        .${buildProduct};

      mandir =
        {
          "client" = "man1";
          "daemon" = "man8";
        }
        .${buildProduct};
    in
    ''
      mkdir -p $out/${bindir} $out/man/${mandir}
    '';

  postInstall = lib.optionalString (buildProduct == "daemon") ''
    pushd $out/sbin
    ln -s in.fingerd fingerd
    popd
  '';

  meta = {
    description =
      {
        "client" = "User information lookup program";
        "daemon" = "Remote user information server";
      }
      .${buildProduct};
    license = lib.licenses.bsdOriginal;
    mainProgram =
      {
        "client" = "finger";
        "daemon" = "fingerd";
      }
      .${buildProduct};
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
