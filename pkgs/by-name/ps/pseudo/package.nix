{
  lib,
  stdenv,
  fetchgit,
  sqlite,
  python3,
  makeWrapper,
  # check inputs
  versionCheckHook,
  acl,
  attr,
  coreutils,
  tcl,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pseudo";
  version = "1.9.8";

  src = fetchgit {
    url = "https://git.yoctoproject.org/pseudo";
    tag = "pseudo-${finalAttrs.version}";
    hash = "sha256-JfKPUpCy5sB4fTQaC7GA+PlkI2jqlMGqF8wbyqVzwzg=";
  };

  postPatch = ''
    patchShebangs .

    substituteInPlace test/test-execl.sh \
      --replace-fail "/usr/bin/env" "${lib.getExe' coreutils "env"}"
    substituteInPlace test/test-env_i.sh \
      --replace-fail "C=C env" "C=C ${lib.getExe' coreutils "env"}"
  '';

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    python3
    makeWrapper
  ];

  buildInputs = [
    sqlite
  ];

  dontDisableStatic = true;

  configureFlags = [
    "--bits=${if stdenv.hostPlatform.is64bit then "64" else "32"}"
    # avoid configure's x86-only arch CFLAGS guess (e.g., -m64)
    "--cflags="
    "--with-sqlite=${lib.getDev sqlite}"
    "--with-sqlite-lib=${lib.getLib sqlite}/lib"
  ];

  doCheck = true;
  checkTarget = "test";
  checkInputs = [
    acl
    attr
    tcl
    which
  ];

  # Provide a minimal database with the users/groups the tests reference.
  preCheck = ''
    export PSEUDO_PASSWD="$NIX_BUILD_TOP/pseudo-passwd"
    mkdir -p "$PSEUDO_PASSWD/etc"
    printf 'root:x:0:0:root:/root:/bin/sh\nbin:x:1:1:bin:/:/sbin/nologin\n' > "$PSEUDO_PASSWD/etc/passwd"
    printf 'root:x:0:\nbin:x:1:\n' > "$PSEUDO_PASSWD/etc/group"
  '';

  installTargets = [
    "install-bin"
    "install-lib"
  ];

  postInstall = ''
    install -Dm644 *.1 -t "$out/usr/share/man/man1"

    # pseudo derives its prefix from argv[0] and defaults its database under it,
    # i.e., into the read-only store. Set the prefix and a writable state dir.
    for prog in pseudo pseudodb pseudolog; do
      wrapProgram "$out/bin/$prog" \
        --set-default PSEUDO_PREFIX "$out" \
        --run 'export PSEUDO_LOCALSTATEDIR="''${PSEUDO_LOCALSTATEDIR:-''${XDG_RUNTIME_DIR:-/tmp/pseudo-$UID}/pseudo}"'
    done
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-V";

  meta = {
    description = "An analogue to sudo and an alternative to fakeroot";
    longDescription = ''
      The pseudo utility offers a way to run commands in a virtualized "root" environment,
      allowing ordinary users to run commands which give the illusion of creating
      device nodes, changing file ownership, and otherwise doing things necessary for
      creating distribution packages or filesystems.
    '';
    mainProgram = "pseudo";
    homepage = "https://git.yoctoproject.org/pseudo";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ veehaitch ];
  };
})
