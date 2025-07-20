{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  buildPackages,
  fetchpatch,
  targetPackages,
}:

stdenv.mkDerivation rec {
  pname = "rpcsvc-proto";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = "rpcsvc-proto";
    rev = "v${version}";
    sha256 = "sha256-DEXzSSmjMeMsr1PoU/ljaY+6b4COUU2Z8MJkGImsgzk=";
  };

  patches = [
    # https://github.com/thkukuk/rpcsvc-proto/pull/14
    (fetchpatch {
      name = "follow-RPCGEN_CPP-env-var";
      url = "https://github.com/thkukuk/rpcsvc-proto/commit/e772270774ff45172709e39f744cab875a816667.diff";
      sha256 = "sha256-KrUD6YwdyxW9S99h4TB21ahnAOgQmQr2tYz++MIbk1Y=";
    })
  ];

  outputs = [
    "out"
    "man"
    "dev"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  RPCGEN_CPP = "${stdenv.cc.targetPrefix}cpp";

  postPatch = ''
    # replace fallback cpp with the target prefixed cpp
    substituteInPlace rpcgen/rpc_main.c \
      --replace 'CPP = "cpp"' \
                'CPP = "${targetPackages.stdenv.cc.targetPrefix}cpp"'
  ''
  + lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    substituteInPlace rpcsvc/Makefile.am \
      --replace '$(top_builddir)/rpcgen/rpcgen' '${buildPackages.rpcsvc-proto}/bin/rpcgen'
  '';

  meta = with lib; {
    homepage = "https://github.com/thkukuk/rpcsvc-proto";
    description = "This package contains rpcsvc proto.x files from glibc, which are missing in libtirpc";
    longDescription = ''
      The RPC-API has been removed from glibc. The 2.32-release-notes
      (https://sourceware.org/pipermail/libc-announce/2020/000029.html) recommend to use
      `libtirpc` and this package instead.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
    mainProgram = "rpcgen";
  };
}
