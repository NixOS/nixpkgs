{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  olm,
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
buildGoModule (finalAttrs: {
  pname = "mautrix-irc";
  version = "0-unstable-2026-09-16";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "irc";
    rev = "b27a77861ab7b6bb3c01677d27a4818f22f8fe6a";
    hash = "sha256-t1m60RGN14/YJ3oc2ZCI2YGYj+mo70Fn+JDkj+Nf7h4=";
  };

  vendorHash = "sha256-5yZi/BuAPe2q07b0rVH2ls9Cc5VPCVGjZePsnDC3sl4=";

  buildInputs = (lib.optional (!withGoolm) olm) ++ (lib.optional withGoolm stdenv.cc.cc.lib);

  tags = lib.optional withGoolm "goolm";

  env = lib.optionalAttrs withGoolm {
    CGO_LDFLAGS = toString [ cppStdLib ];
  };

  doCheck = true;
  preCheck = ''
    # Needed by the tests to be able to find libstdc++
    export LD_LIBRARY_PATH="${stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"
  ''
  + (lib.optionalString (!withGoolm) ''
    # When using libolm, the tests need explicit linking to libstdc++
    export CGO_LDFLAGS="${cppStdLib}"
  '');

  # fails without specific test data
  # checkFlags = [
  #   "-skip=^TestGetEventsEventQueueResponse$"
  # ];

  postCheck = ''
    unset LD_LIBRARY_PATH
  '';

  meta = {
    homepage = "https://github.com/mautrix/irc";
    description = "Matrix-IRC puppeting bridge";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      logn
    ];
    mainProgram = "mautrix-irc";
  };
})
