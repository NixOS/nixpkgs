{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, php
, brotli
, testers
, frankenphp
, cctools
, darwin
, libiconv
, pkg-config
, makeBinaryWrapper
, runCommand
, writeText
}:

let
  phpEmbedWithZts = php.override {
    embedSupport = true;
    ztsSupport = true;
    staticSupport = stdenv.isDarwin;
    zendSignalsSupport = false;
    zendMaxExecutionTimersSupport = stdenv.isLinux;
  };
  phpUnwrapped = phpEmbedWithZts.unwrapped;
  phpConfig = "${phpUnwrapped.dev}/bin/php-config";
  pieBuild = stdenv.hostPlatform.isMusl;
in buildGoModule rec {
  pname = "frankenphp";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "dunglas";
    repo = "frankenphp";
    rev = "v${version}";
    hash = "sha256-ZM8/1u4wIBHUgq2x8zyDJhf+qFQz4u5fhLNLaqAv/54=";
  };

  sourceRoot = "${src.name}/caddy";

  # frankenphp requires C code that would be removed with `go mod tidy`
  # https://github.com/golang/go/issues/26366
  proxyVendor = true;
  vendorHash = "sha256-3Y5STb521iRois/KLQqdTxxTYdp39PTaiJEBjWrZsyw=";

  buildInputs = [ phpUnwrapped brotli ] ++ phpUnwrapped.buildInputs;
  nativeBuildInputs = [ makeBinaryWrapper ] ++ lib.optionals stdenv.isDarwin [ pkg-config cctools darwin.autoSignDarwinBinariesHook ];

  subPackages = [ "frankenphp" ];

  tags = [ "cgo" "netgo" "ousergo" "static_build" ];

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/caddyserver/caddy/v2.CustomVersion=FrankenPHP ${version} PHP ${phpUnwrapped.version} Caddy'"
    # pie mode is only available with pkgsMusl, it also automatically add -buildmode=pie to $GOFLAGS
  ]  ++ (lib.optional pieBuild [ "-static-pie" ]);

  preBuild = ''
    export CGO_CFLAGS="$(${phpConfig} --includes)"
    export CGO_LDFLAGS="-DFRANKENPHP_VERSION=${version} \
      $(${phpConfig} --ldflags) \
      $(${phpConfig} --libs)"
  '' + lib.optionalString stdenv.isDarwin ''
    # replace hard-code homebrew path
    substituteInPlace ../frankenphp.go \
      --replace "-L/opt/homebrew/opt/libiconv/lib" "-L${libiconv}/lib"
  '';

  preFixup = ''
    mkdir -p $out/lib
    ln -s "${phpEmbedWithZts}/lib/php.ini" "$out/lib/frankenphp.ini"

    wrapProgram $out/bin/frankenphp --set-default PHP_INI_SCAN_DIR $out/lib
  '';

  doCheck = false;

  passthru = {
    php = phpEmbedWithZts;
    tests = {
      # TODO: real NixOS test with Symfony application
      version = testers.testVersion {
        inherit version;
        package = frankenphp;
        command = "frankenphp version";
      };
      phpinfo = runCommand "php-cli-phpinfo" {
        phpScript = writeText "phpinfo.php" ''
          <?php phpinfo();
        '';
      } ''
        ${lib.getExe frankenphp} php-cli $phpScript > $out
      '';
    };
  };

  meta = {
    changelog = "https://github.com/dunglas/frankenphp/releases/tag/v${version}";
    description = "Modern PHP app server";
    homepage = "https://github.com/dunglas/frankenphp";
    license = lib.licenses.mit;
    mainProgram = "frankenphp";
    maintainers = with lib.maintainers; [ gaelreyrol shyim ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
