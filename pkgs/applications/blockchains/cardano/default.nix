{ lib, stdenv, fetchFromGitHub, callPackage, haskell, libsodium, cddl, cbor-diag }:

let
  pname = "cardano-wallet";
  version = "2022-01-18";

  src = fetchFromGitHub {
    owner = "input-output-hk";
    repo = "cardano-wallet";
    rev = "v${version}";
    sha256 = "1apzfy7qdgf6l0lb3icqz3rvaq2w3a53xq6wvhqnbfi8i7cacy03";
  };

  cardano-mainnet-mirror = callPackage ./cardano-mainnet-mirror.nix { };

  hsPkgs = haskell.packages.ghc8107.override {
    overrides = self: super: with haskell.lib.compose; {
      # cardano-addresses
      cardano-addresses = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-addresses.nix { hspec-golden = super.hspec-golden_0_1_0_3; });

      cardano-addresses-cli = overrideCabal (drv: {
        preCheck = ''export PATH="$PWD/dist/build/cardano-address:$PATH"'';
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-addresses-cli.nix { cardano-address = null; });

      # cardano-base
      base-deriving-via = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/base-deriving-via.nix { });

      cardano-binary = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-binary.nix { });

      cardano-binary-test = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-binary-test.nix { });

      cardano-crypto-class = overrideCabal (drv: {
        buildDepends = (drv.buildDepends or []) ++ [ libsodium ];
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-crypto-class.nix { });

      cardano-crypto-praos = overrideCabal (drv: {
        configureFlags = (drv.configureFlags or []) ++ [ "-f" "-external-libsodium-vrf" ];
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-crypto-praos.nix { });

      cardano-crypto-tests = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-crypto-tests.nix { });

      cardano-slotting = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-slotting.nix { });

      measures = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/measures.nix { });

      orphans-deriving-via = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/orphans-deriving-via.nix { });

      strict-containers = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/strict-containers.nix { });

      # cardano-config
      cardano-config = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-config.nix { });

      # cardano-crypto
      cardano-crypto = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-crypto.nix { });

      # cardano-ledger
      byron-spec-chain = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/byron-spec-chain.nix { });

      byron-spec-ledger = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/byron-spec-ledger.nix { });

      cardano-crypto-test = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-crypto-test.nix { });

      cardano-crypto-wrapper = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-crypto-wrapper.nix { });

      cardano-data = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-data.nix { });

      cardano-ledger-alonzo = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-ledger-alonzo.nix { });

      cardano-ledger-byron = overrideCabal (drv: {
        jailbreak = true;
        preCheck = ''
          export CARDANO_MAINNET_MIRROR="${cardano-mainnet-mirror}/epochs"
        '';
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-ledger-byron.nix { });

      cardano-ledger-byron-test = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-ledger-byron-test.nix { });

      cardano-ledger-core = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-ledger-core.nix { });

      cardano-ledger-pretty = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-ledger-pretty.nix { });

      cardano-ledger-shelley = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-ledger-shelley.nix { });

      cardano-ledger-shelley-test = overrideCabal (drv: {
        testToolDepends = (drv.testToolDepends or []) ++ [ cddl cbor-diag ];
        testFlags = [
          "-p" "!/ShelleyGenesis JSON golden test/"
        ];
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-ledger-shelley-test.nix { });

      cardano-ledger-shelley-ma = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-ledger-shelley-ma.nix { });

      cardano-protocol-tpraos = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-protocol-tpraos.nix { });

      compact-map = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/compact-map.nix { });

      non-integral = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/non-integral.nix { });

      set-algebra = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/set-algebra.nix { });

      small-steps = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/small-steps.nix { });

      small-steps-test = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/small-steps-test.nix { });

      # cardano-node
      cardano-api = overrideCabal (drv: {
        jailbreak = true;
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-api.nix { });

      cardano-cli = overrideCabal (drv: {
        doCheck = false; # cabal cannot find library cardano-api:gen
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-cli.nix { });

      cardano-node = overrideCabal (drv: {
        jailbreak = true;
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-node.nix { });

      # cardano-prelude
      cardano-prelude = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-prelude.nix { });

      cardano-prelude-test = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-prelude-test.nix { });

      # cardano-sl-x509
      cardano-sl-x509 = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-sl-x509.nix { });

      # cardano-wallet
      cardano-numeric = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-numeric.nix { });

      cardano-wallet = overrideCabal (drv: {
        testToolDepends = (drv.testToolDepends or []) ++ [ self.cardano-cli self.cardano-node ];
        preCheck = ''export PATH="$PWD/dist/build/cardano-wallet:$PATH"'';
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-wallet.nix { });

      cardano-wallet-cli = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-wallet-cli.nix { });

      cardano-wallet-core = overrideCabal (drv: {
        jailbreak = true;
        doCheck = false;
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-wallet-core.nix { });

      cardano-wallet-core-integration = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-wallet-core-integration.nix { });

      cardano-wallet-launcher = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-wallet-launcher.nix { });

      cardano-wallet-test-utils = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/cardano-wallet-test-utils.nix { });

      dbvar = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/dbvar.nix { });

      strict-non-empty-containers = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/strict-non-empty-containers.nix { });

      text-class = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/text-class.nix { });

      # goblins
      goblins = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/goblins.nix { });

      # hedgehog-extras
      hedgehog-extras = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/hedgehog-extras.nix { });

      # iohk-monitoring-framework
      contra-tracer = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/contra-tracer.nix { });

      iohk-monitoring = overrideCabal (drv: {
        testFlags = [
          "-p" "!(/parsed representation/||/static representation/)"
        ];
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/iohk-monitoring.nix { });

      lobemo-backend-aggregation = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/lobemo-backend-aggregation.nix { });

      lobemo-backend-ekg = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/lobemo-backend-ekg.nix { });

      lobemo-backend-monitoring = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/lobemo-backend-monitoring.nix { });

      lobemo-backend-trace-forwarder = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/lobemo-backend-trace-forwarder.nix { });

      lobemo-scribe-systemd = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/lobemo-scribe-systemd.nix { });

      tracer-transformers = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/tracer-transformers.nix { });

      # optparse-applicative
      optparse-applicative-fork = overrideCabal (drv: {
        doCheck = false;
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/optparse-applicative-fork.nix { });

      # ouroboros-network
      io-classes = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/io-classes.nix { });

      io-sim = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/io-sim.nix { });

      monoidal-synchronisation = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/monoidal-synchronisation.nix { });

      ntp-client = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/ntp-client.nix { });

      network-mux = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/network-mux.nix { });

      ouroboros-consensus = overrideCabal (drv: {
        jailbreak = true;
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/ouroboros-consensus.nix { });

      ouroboros-consensus-byron = overrideCabal (drv: {
        jailbreak = true;
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/ouroboros-consensus-byron.nix { cryptonite = super.cryptonite_0_27; });

      ouroboros-consensus-cardano = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/ouroboros-consensus-cardano.nix { });

      ouroboros-consensus-protocol = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/ouroboros-consensus-protocol.nix { });

      ouroboros-consensus-shelley = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/ouroboros-consensus-shelley.nix { });

      ouroboros-network = overrideCabal (drv: {
        testToolDepends = (drv.testToolDepends or []) ++ [ cbor-diag cddl ];
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/ouroboros-network.nix { });

      ouroboros-network-framework = overrideCabal (drv: {
        jailbreak = true;
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/ouroboros-network-framework.nix { });

      ouroboros-network-testing = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/ouroboros-network-testing.nix { });

      strict-stm = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/strict-stm.nix { });

      typed-protocols = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/typed-protocols.nix { });

      typed-protocols-cborg = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/typed-protocols-cborg.nix { });

      typed-protocols-examples = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/typed-protocols-examples.nix { });

      # plutus
      plutus-core = overrideCabal (drv: {
        jailbreak = true;
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/plutus-core.nix { ral = super.ral_0_1; });

      plutus-ledger-api = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/plutus-ledger-api.nix { });

      plutus-tx = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/plutus-tx.nix { });

      prettyprinter-configurable = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/prettyprinter-configurable.nix { });

      word-array = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/word-array.nix { });

      # Win32-network
      Win32-network = overrideCabal (drv: {
        maintainers = with lib.maintainers; [ leifhelm ];
      }) (self.callPackage ./packages/Win32-network.nix { });

      # other
      aeson = super.aeson_1_5_6_0;
      http2 = super.http2_3_0_2;
      flat = self.callPackage ./packages/flat.nix { };
    };
  };
in
{
  inherit (hsPkgs) cardano-addresses cardano-cli cardano-node cardano-wallet;
}
