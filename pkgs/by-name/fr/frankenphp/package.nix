{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  php,
  brotli,
  watcher,
  cctools,
  darwin,
  libiconv,
  pkg-config,
  makeBinaryWrapper,
  runCommand,
  writeText,
  versionCheckHook,
}:

let
  phpEmbedWithZts = php.override {
    embedSupport = true;
    ztsSupport = true;
    staticSupport = stdenv.hostPlatform.isDarwin;
    zendSignalsSupport = false;
    zendMaxExecutionTimersSupport = stdenv.hostPlatform.isLinux;
  };
  phpUnwrapped = phpEmbedWithZts.unwrapped;
  phpConfig = "${phpUnwrapped.dev}/bin/php-config";
  pieBuild = stdenv.hostPlatform.isMusl;
in
buildGoModule (finalAttrs: {
  pname = "frankenphp";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "php";
    repo = "frankenphp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JzZXg/tkSZqLZn56RyLb8Q8SaeG/tHA8Sqxu99s5ks0=";
  };

  sourceRoot = "${finalAttrs.src.name}/caddy";

  # frankenphp requires C code that would be removed with `go mod tidy`
  # https://github.com/golang/go/issues/26366
  proxyVendor = true;
  vendorHash = "sha256-9RHD2ZcolhgQO0UKxkqFjxXGAVijSYQxVt7s+/aXNIo=";

  buildInputs = [
    phpUnwrapped
    brotli
    watcher
  ]
  ++ phpUnwrapped.buildInputs;
  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    pkg-config
    cctools
    darwin.autoSignDarwinBinariesHook
    libiconv
  ];

  subPackages = [ "frankenphp" ];

  tags = [
    "cgo"
    "netgo"
    "ousergo"
    "static_build"
    "nobadger"
    "nomysql"
    "nopgx"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/caddyserver/caddy/v2.CustomVersion=FrankenPHP ${finalAttrs.version} PHP ${phpUnwrapped.version} Caddy'"
    # pie mode is only available with pkgsMusl, it also automatically add -buildmode=pie to $GOFLAGS
  ]
  ++ (lib.optional pieBuild [ "-static-pie" ]);

  preBuild = ''
    export CGO_CFLAGS="$(${phpConfig} --includes)"
    export CGO_LDFLAGS="-DFRANKENPHP_VERSION=${finalAttrs.version} \
      $(${phpConfig} --ldflags) \
      $(${phpConfig} --libs)"
  '';

  preFixup = ''
    mkdir -p $out/lib
    ln -s "${phpEmbedWithZts}/lib/php.ini" "$out/lib/frankenphp.ini"

    wrapProgram $out/bin/frankenphp --set-default PHP_INI_SCAN_DIR $out/lib
  '';

  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru = {
    php = phpEmbedWithZts;
    tests = {
      # TODO: real NixOS test with Symfony application
      phpinfo =
        runCommand "php-cli-phpinfo"
          {
            phpScript = writeText "phpinfo.php" ''
              <?php phpinfo();
            '';
          }
          ''
            ${lib.getExe finalAttrs.finalPackage} php-cli $phpScript > $out
          '';
    };
  };

  meta = {
    changelog = "https://github.com/php/frankenphp/releases/tag/v${finalAttrs.version}";
    description = "Modern PHP app server";
    homepage = "https://github.com/php/frankenphp";
    license = lib.licenses.mit;
    mainProgram = "frankenphp";
    maintainers = [ lib.maintainers.piotrkwiecinski ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
