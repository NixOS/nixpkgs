{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  olm,
  libsignal-ffi,
  zlib,
  versionCheckHook,
  # This option enables the use of an experimental pure-Go implementation of
  # the Olm protocol instead of libolm for end-to-end encryption. Using goolm
  # is not recommended by the mautrix developers, but they are interested in
  # people trying it out in non-production-critical environments and reporting
  # any issues they run into.
  withGoolm ? false,
}:

let
  cppStdLib = if stdenv.hostPlatform.isDarwin then "-lc++" else "-lstdc++";
in
buildGoModule rec {
  pname = "mautrix-signal";
  version = "26.01";
  tag = "v0.2601.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "signal";
    inherit tag;
    hash = "sha256-zvB0CbSzrLcUJiEIj3vtDq2C0XEYUNRbaUAn+636+uk=";
  };

  buildInputs =
    (lib.optional (!withGoolm) olm)
    ++ (lib.optional withGoolm stdenv.cc.cc.lib)
    ++ [
      # must match the version used in https://github.com/mautrix/signal/tree/main/pkg/libsignalgo
      # see https://github.com/mautrix/signal/issues/401
      libsignal-ffi
      zlib
    ];

  tags = lib.optional withGoolm "goolm";

  CGO_LDFLAGS = lib.optional withGoolm [ cppStdLib ];

  vendorHash = "sha256-Eo7T/63ywNnn/t0RzjwkSYRmrL0IMdIsv4wqrQFv+5U=";

  ldflags = [
    "-X"
    "main.Tag=${tag}"
  ];

  doCheck = true;
  preCheck = ''
    # Needed by the tests to be able to find libstdc++
    export LD_LIBRARY_PATH="${stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"
  ''
  + (lib.optionalString (!withGoolm) ''
    # When using libolm, the tests need explicit linking to libstdc++
    export CGO_LDFLAGS="${cppStdLib}"
  '');

  postCheck = ''
    unset LD_LIBRARY_PATH
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    homepage = "https://github.com/mautrix/signal";
    description = "Matrix-Signal puppeting bridge";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      pentane
      ma27
      SchweGELBin
    ];
    mainProgram = "mautrix-signal";
  };
}
