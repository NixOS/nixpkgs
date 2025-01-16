{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, mkYarnPackage
, buildGoModule
, nodejs
, yarn
, gnumake
, go
, git
, fixup_yarn_lock
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
    "-s -w"
    "-X github.com/lightningnetwork/lnd/build.Commit=b5117a483a8dd8418e28b87531f130655b990825"
    "-X github.com/lightningnetwork/lnd/build.CommitHash=8bba79222f439127e46ec3ff7ec7c650e0d88d56"
    "-X github.com/lightningnetwork/lnd/build.GoVersion=go1.22.3"
    "-X github.com/lightningnetwork/lnd/build.RawTags=litd,autopilotrpc,signrpc,walletrpc,chainrpc,invoicesrpc,watchtowerrpc,neutrinorpc,peersrpc"
    "-X github.com/lightninglabs/lightning-terminal.appFilesPrefix="
    "-X github.com/lightninglabs/lightning-terminal.Commit=b5117a483a8dd8418e28b87531f130655b990825"
    "-X github.com/lightninglabs/loop.Commit=23b818e436ddf24013ad5a617a503801de53d783"
    "-X github.com/lightninglabs/pool.Commit=e5d6a5ff0bc52df7a5b025b8098e709722a44d96"
    "-X github.com/lightninglabs/taproot-assets.Commit=564795a0e4c1d1034493b498f58a552920f2e39c"
  ];

  subPackages = [ "cmd/litcli" "cmd/litd" ];

  tags = [
    "litd"
    "autopilotrpc"
    "signrpc"
    "walletrpc"
    "chainrpc"
    "invoicesrpc"
    "watchtowerrpc"
    "neutrinorpc"
    "peersrpc"
  ];

  postInstall = ''
    cp -r $out/bin/* $out/
  '';

  meta = with lib; {
    description =
      "All-in-one Lightning node management tool that includes LND, Loop, Pool, Faraday, and Tapd.";
    homepage = "https://github.com/lightninglabs/lightning-terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ HannahMR ];
    mainProgram = "litd";
  };
}
