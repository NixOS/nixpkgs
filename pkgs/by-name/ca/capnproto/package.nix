{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  makeSetupHook,
  cmake,
  openssl,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "capnproto";
  version = "1.1.0";

  # release tarballs are missing some ekam rules
  src = fetchFromGitHub {
    owner = "capnproto";
    repo = "capnproto";
    rev = "v${version}";
    hash = "sha256-gxkko7LFyJNlxpTS+CWOd/p9x/778/kNIXfpDGiKM2A=";
  };

  nativeBuildInputs = [ cmake ];

  propagatedNativeBuildInputs = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    (makeSetupHook {
      name = "capnproto-setup-hook";
      substitutions = {
        build_capnp = buildPackages.capnproto;
      };
    } ./setup-hook.sh)
  ];

  propagatedBuildInputs = [
    openssl
    zlib
  ];

  meta = with lib; {
    homepage = "https://capnproto.org/";
    description = "Cap'n Proto cerealization protocol";
    longDescription = ''
      Cap’n Proto is an insanely fast data interchange format and
      capability-based RPC system. Think JSON, except binary. Or think Protocol
      Buffers, except faster.
    '';
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
