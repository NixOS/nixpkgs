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
  nix-update-script,
}:

let
  cppStdLib = if stdenv.hostPlatform.isDarwin then "-lc++" else "-lstdc++";
in
buildGoModule (finalAttrs: {
  pname = "mautrix-irc";
  version = "0-unstable-2026-11-16";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "irc";
    rev = "74b255b83442e15b5f8fc76e22f5b019a6b92109";
    hash = "sha256-jGRNIVfjMj5Q33rbPLJbr56aTTdMtcQxGp/H8EHNvA4=";
  };

  vendorHash = "sha256-bwVevusCt1uJYyX65j8bWFji+IG13xa8awfi7eaPO9A=";

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

  passthru.updateScript = nix-update-script { };

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
