{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  mkYarnPackage,
  buildGoModule,
  nodejs,
  yarn,
  gnumake,
  go,
  git,
  fixup_yarn_lock
}:

buildGoModule rec {
  pname = "lightning-terminal";
  version = "0.12.4-alpha";
  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "lightning-terminal";
    rev = "v${version}";
    hash = "sha256-gGo9abd12zZPPTBkmEfB8BNK1ZVpea2uZNpeYRb5l00=";
  };

  app = mkYarnPackage {
    name = "lightning-app";
    src = "${src}/app";
    packageJSON = "${src}/app/package.json";
    yarnLock = "${src}/app/yarn.lock";
  };

  vendorHash = "sha256-MwVTmwOb0wW2e9lEbr/Pm2IhHXizwEgaw5j+x8+XA+E=";

  ldflags = [
    "-s" "-w"
    "-X" "github.com/lightningnetwork/lnd/build.Commit=lightning-terminal-"
    "-X" "github.com/lightningnetwork/lnd/build.CommitHash="
    "-X" "github.com/lightningnetwork/lnd/build.GoVersion="
    "-X" "github.com/lightningnetwork/lnd/build.RawTags=litd,autopilotrpc,signrpc,walletrpc,chainrpc,invoicesrpc,watchtowerrpc,neutrinorpc,peersrpc"
    "-X" "github.com/lightninglabs/lightning-terminal.appFilesPrefix="
    "-X" "github.com/lightninglabs/lightning-terminal.Commit="
    "-X" "github.com/lightninglabs/loop.Commit=v0.26.6-beta"
    "-X" "github.com/lightninglabs/pool.Commit=v0.6.4-beta.0.20231003174306-80d8854a0c4b"
    "-X" "github.com/lightninglabs/taproot-assets.Commit=v0.3.2"
  ];

  subPackages = [ "cmd/litcli" "cmd/litd" ];

  tags = [
    "litd" "autopilotrpc" "signrpc"
    "walletrpc" "chainrpc" "invoicesrpc"
    "watchtowerrpc" "neutrinorpc" "peersrpc"
  ];

  postInstall = ''
    cp -r $out/bin/* $out/
    ls $out/bin
  '';

  meta = with lib; {
    description = "An all-in-one Lightning node management tool that includes LND, Loop, Pool, Faraday, and Tapd.";
    homepage = "https://github.com/lightninglabs/lightning-terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ HannahMR ];
    mainProgram = "litd";
  };
}
