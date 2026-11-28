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
  nix-update-script,
}:

let
  cppStdLib = if stdenv.hostPlatform.isDarwin then "-lc++" else "-lstdc++";
in
buildGoModule (finalAttrs: {
  pname = "mautrix-gvoice";
  version = "26.11";
  tag = "v0.${lib.replaceStrings [ "." ] [ "" ] finalAttrs.version}.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "gvoice";
    tag = finalAttrs.tag;
    hash = "sha256-0DUe+MeExB3/wF6IIwoW9iDrn2RRRh6ixm6fKt6jF0o=";
  };

  vendorHash = "sha256-90g2yajwy3fdDwzftXdoYiLTSeYIK9IApzZ3KWj1k8w=";

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

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/mautrix/gvoice";
    description = "Matrix-Google Voice puppeting bridge";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      logn
    ];
    mainProgram = "mautrix-gvoice";
  };
})
