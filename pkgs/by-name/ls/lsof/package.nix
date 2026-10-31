{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  perl,
  which,
  ncurses,
  nukeReferences,
  freebsd,
  ed,
  installShellFiles,
}:

let
  dialect = lib.last (lib.splitString "-" stdenv.hostPlatform.system);
in

stdenv.mkDerivation (finalAttrs: {
  pname = "lsof";
  version = "4.99.7";

  src = fetchFromGitHub {
    owner = "lsof-org";
    repo = "lsof";
    tag = finalAttrs.version;
    hash = "sha256-o95osjMQvpOVx2b0lCXVp61x2GHQV+HW1iaamVhevng=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;
  doCheck = false; # Does not play well with the Nix sandbox
  outputs = [
    "out"
    "man"
  ];

  postPatch = ''
    patchShebangs --build lib/dialects/*/Mksrc
  ''
  # Do not re-build version.h in every 'make' to allow nuke-refs below.
  # We remove phony 'FRC' target that forces rebuilds:
  #   'version.h: FRC ...' is translated to 'version.h: ...'.
  + ''
    sed -i lib/dialects/*/Makefile -e 's/version.h:\s*FRC/version.h:/'
  ''
  # help Configure find libproc.h in $SDKROOT
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i -e 's|lcurses|lncurses|g' \
           -e "s|/Library.*/MacOSX.sdk/|\"$SDKROOT\"/|" Configure
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    nukeReferences
    perl
    which
    ed
    installShellFiles
  ];
  buildInputs = [ ncurses ];

  configurePhase =
    let
      toVar = name: value: "${name}=\"${value}\"";
      configEnv = {
        LSOF_CC = "$CC";
        LSOF_AR = "$AR cr";
        LSOF_RANLIB = "$RANLIB";
      }
      // lib.optionalAttrs stdenv.hostPlatform.isLinux {
        LINUX_CONF_CC = "$CC_FOR_BUILD";
      }
      // lib.optionalAttrs stdenv.hostPlatform.isFreeBSD {
        FREEBSD_SYS = "${freebsd.sys.src}/sys";
      };
    in
    ''
      runHook preConfigure
      ${lib.concatMapAttrsStringSep " " toVar configEnv} ./Configure -n ${dialect}
      runHook postConfigure
    '';

  preBuild = ''
    for filepath in $(find lib/dialects/${dialect} -type f); do
      sed -i "s,/usr/include,$LSOF_INCLUDE,g" $filepath
    done

    # Wipe out development-only flags from CFLAGS embedding
    make version.h
    nuke-refs version.h
  '';

  # Fix references from man page https://github.com/lsof-org/lsof/issues/66
  preInstall = ''
    substituteInPlace Lsof.8 \
      --replace-fail ".so ./00DIALECTS" "" \
      --replace-fail ".so ./version" ".ds VN ${finalAttrs.version}"
  '';

  installPhase = ''
    runHook preInstall
    installManPage --name lsof.8 Lsof.8
    installBin lsof
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/lsof-org/lsof";
    changelog = "https://github.com/lsof-org/lsof/releases/tag/${finalAttrs.src.tag}";
    description = "Tool to list open files";
    mainProgram = "lsof";
    longDescription = ''
      List open files. Can show what process has opened some file,
      socket (IPv6/IPv4/UNIX local), or partition (by opening a file
      from it).
    '';
    license = lib.licenses.lsof;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
