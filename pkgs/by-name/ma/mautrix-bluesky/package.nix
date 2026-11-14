{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  olm,
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
buildGoModule (finalAttrs: {
  pname = "mautrix-bluesky";
  version = "25.10";
  tag = "v0.${lib.replaceStrings [ "." ] [ "" ] finalAttrs.version}.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "bluesky";
    tag = finalAttrs.tag;
    hash = "sha256-tADkD2WSATOubXiLX76qoqFp5aOst62qx40TjhLN2os=";
  };

  vendorHash = "sha256-4vX9KV2+TMxKkO7OGTazhDF9jx5/HNbenSUIN8qajLs=";

  buildInputs = (lib.optional (!withGoolm) olm) ++ (lib.optional withGoolm stdenv.cc.cc.lib);

  tags = lib.optional withGoolm "goolm";

  env = lib.optionalAttrs withGoolm {
    CGO_LDFLAGS = toString [ cppStdLib ];
  };

  ldflags = [
    "-X"
    "main.Tag=${finalAttrs.tag}"
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
    homepage = "https://github.com/mautrix/bluesky";
    description = "Matrix-Bluesky DM puppeting bridge";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      logn
    ];
    mainProgram = "mautrix-bluesky";
  };
})
