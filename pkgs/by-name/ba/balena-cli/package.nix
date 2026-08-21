{
  lib,
  stdenv,
  balena-compose-parser,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  node-gyp,
  python3,
  udev,
  xcbuild,
}:

buildNpmPackage (finalAttrs: {
  pname = "balena-cli";
  version = "25.2.5";

  src = fetchFromGitHub {
    owner = "balena-io";
    repo = "balena-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8o06p2tCxqe95kZRaLlybqUGDbMrlRqF+ITQP8CD75I=";
  };

  npmDepsHash = "sha256-jAG2MXGPqoohfrYkg8lSVQtvD9PBYC1OZLdxR0HS71w=";

  makeCacheWritable = true;

  nativeBuildInputs = [
    node-gyp
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ];

  env = {
    # This is a bit heavy handed but resolves errors stemming from the Node.js
    # USB package, such as
    #
    # > /build/source/node_modules/usb/node_modules/node-addon-api/napi-inl.h:1433:8: note: 'std::string_view' is only available from C++17 onwards
    #
    # The issue seems to have been resolved upstream but not released yet:
    # https://github.com/node-usb/node-usb/pull/964
    CXXFLAGS = "-std=c++20";
  };

  postInstall = ''
    cp ${lib.getExe balena-compose-parser} $out/lib/node_modules/balena-cli/node_modules/@balena/compose-parser/bin/
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  # Disabled on Darwin due to:
  #
  # https://github.com/NixOS/nix/issues/5748
  #
  # No matter whether $TMP and $HOME point to real writable directories, the
  # Darwin sandbox tries to use /var/empty and fails.
  doInstallCheck = !stdenv.hostPlatform.isDarwin;
  versionCheckProgram = "${placeholder "out"}/bin/balena";

  meta = {
    description = "Command line interface for balenaCloud or openBalena";
    longDescription = ''
      The balena CLI is a Command Line Interface for balenaCloud or openBalena. It is a software
      tool available for Windows, macOS and Linux, used through a command prompt / terminal window.
      It can be used interactively or invoked in scripts. The balena CLI builds on the balena API
      and the balena SDK, and can also be directly imported in Node.js applications.
    '';
    homepage = "https://github.com/balena-io/balena-cli";
    changelog = "https://github.com/balena-io/balena-cli/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kalebpace
    ];
    mainProgram = "balena";
  };
})
