{
  version,
  sha256,
  platforms,
  patches ? [ ],
}:

{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  docutils,
  makeWrapper,
  fuse3,
  macfuse-stubs,
  glib,
  which,
  python3Packages,
  openssh,
}:

let
  fuse = if stdenv.hostPlatform.isDarwin then macfuse-stubs else fuse3;
in
stdenv.mkDerivation rec {
  pname = "sshfs-fuse";
  inherit version;

  src = fetchFromGitHub {
    owner = "libfuse";
    repo = "sshfs";
    rev = "sshfs-${version}";
    inherit sha256;
  };

  inherit patches;

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    docutils
    makeWrapper
  ];
  buildInputs = [
    fuse
    glib
  ];
  nativeCheckInputs = [
    which
    python3Packages.pytest
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.hostPlatform.system == "i686-linux"
  ) "-D_FILE_OFFSET_BITS=64";

  postInstall =
    ''
      mkdir -p $out/sbin
      ln -sf $out/bin/sshfs $out/sbin/mount.sshfs
    ''
    + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      wrapProgram $out/bin/sshfs --prefix PATH : "${openssh}/bin"
    '';

  # doCheck = true;
  checkPhase = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    # The tests need fusermount:
    mkdir bin
    cp ${fuse}/bin/fusermount3 bin/fusermount
    export PATH=bin:$PATH
    # Can't access /dev/fuse within the sandbox: "FUSE kernel module does not seem to be loaded"
    substituteInPlace test/util.py --replace "/dev/fuse" "/dev/null"
    # TODO: "fusermount executable not setuid, and we are not root"
    # We should probably use a VM test instead
    ${python3Packages.python.interpreter} -m pytest test/
  '';

  meta = with lib; {
    inherit platforms;
    description = "FUSE-based filesystem that allows remote filesystems to be mounted over SSH";
    longDescription = macfuse-stubs.warning;
    homepage = "https://github.com/libfuse/sshfs";
    license = licenses.gpl2Plus;
    mainProgram = "sshfs";
    maintainers = with maintainers; [ ];
  };
}
