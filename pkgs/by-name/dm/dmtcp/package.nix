{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  perl,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dmtcp";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "dmtcp";
    repo = "dmtcp";
    tag = finalAttrs.version;
    hash = "sha256-5laifZ/8oYJrNO5JOggCbPKmA9XiHEC79C/hk+0TdeQ=";
  };

  dontDisableStatic = true;

  nativeCheckInputs = [
    perl
    python3
  ];
  env.HAS_PYTHON3 = "yes";

  patches = [ ./ld-linux-so-buffer-size.patch ];

  postPatch = ''
    patchShebangs .

    substituteInPlace configure \
      --replace-fail '#define ELF_INTERPRETER \"$interp\"' \
                "#define ELF_INTERPRETER \\\"$(cat $NIX_CC/nix-support/dynamic-linker)\\\""
    substituteInPlace src/restartscript.cpp \
      --replace-fail /bin/bash ${stdenv.shell}
    substituteInPlace util/dmtcp_restart_wrapper.sh \
      --replace-fail /bin/bash ${stdenv.shell}
    substituteInPlace test/autotest.py \
      --replace-fail /bin/bash ${bash}/bin/bash \
      --replace-fail /usr/bin/perl ${perl}/bin/perl \
      --replace-fail '/usr/bin/env python3' ${python3.interpreter} \
      --replace-fail "os.environ['USER']" "\"nixbld1\"" \
      --replace-fail "os.getenv('USER')" "\"nixbld1\""
  '';

  meta = {
    description = "Distributed MultiThreaded Checkpointing";
    longDescription = ''
      DMTCP (Distributed MultiThreaded Checkpointing) is a tool to
      transparently checkpointing the state of an arbitrary group of
      programs spread across many machines and connected by sockets. It does
      not modify the user's program or the operating system.
    '';
    homepage = "http://dmtcp.github.io/";
    license = lib.licenses.lgpl3Plus; # most files seem this or LGPL-2.1+
    platforms = lib.intersectLists lib.platforms.linux (
      lib.platforms.x86 ++ lib.platforms.aarch ++ lib.platforms.riscv
    );
  };
})
