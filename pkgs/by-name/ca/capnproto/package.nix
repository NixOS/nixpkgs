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
  version = "1.0.2";

  # release tarballs are missing some ekam rules
  src = fetchFromGitHub {
    owner = "capnproto";
    repo = "capnproto";
    rev = "v${version}";
    sha256 = "sha256-LVdkqVBTeh8JZ1McdVNtRcnFVwEJRNjt0JV2l7RkuO8=";
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
