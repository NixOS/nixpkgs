{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  perl,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "dmtcp";
  version = "unstable-2022-02-28";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "133687764c6742906006a1d247e3b83cd860fa1d";
    hash = "sha256-9Vr8IhoeATCfyt7Lp7kYe/7e87mFX9KMNGTqxJgIztE=";
  };

  dontDisableStatic = true;

  patches = [ ./ld-linux-so-buffer-size.patch ];

  postPatch = ''
    patchShebangs .

    substituteInPlace configure \
      --replace '#define ELF_INTERPRETER "$interp"' \
                "#define ELF_INTERPRETER \"$(cat $NIX_CC/nix-support/dynamic-linker)\""
    substituteInPlace src/restartscript.cpp \
      --replace /bin/bash ${stdenv.shell}
    substituteInPlace util/dmtcp_restart_wrapper.sh \
      --replace /bin/bash ${stdenv.shell}
    substituteInPlace test/autotest.py \
      --replace /bin/bash ${bash}/bin/bash \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace /usr/bin/python ${python3.interpreter} \
      --replace "os.environ['USER']" "\"nixbld1\"" \
      --replace "os.getenv('USER')" "\"nixbld1\""
  '';

  meta = with lib; {
    description = "Distributed MultiThreaded Checkpointing";
    longDescription = ''
      DMTCP (Distributed MultiThreaded Checkpointing) is a tool to
      transparently checkpointing the state of an arbitrary group of
      programs spread across many machines and connected by sockets. It does
      not modify the user's program or the operating system.
    '';
    homepage = "http://dmtcp.sourceforge.net/";
    license = licenses.lgpl3Plus; # most files seem this or LGPL-2.1+
    platforms = intersectLists platforms.linux platforms.x86; # broken on ARM and Darwin
  };
}
