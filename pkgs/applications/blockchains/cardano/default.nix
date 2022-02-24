{ stdenv, fetchFromGitHub, callPackage, haskell, libsodium, cddl, cbor-diag }:

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
      cardano-addresses = self.callPackage ./packages/cardano-addresses.nix { hspec-golden = super.hspec-golden_0_1_0_3; };
      cardano-addresses-cli = overrideCabal (drv: {
        preCheck = ''export PATH="$PWD/dist/build/cardano-address:$PATH"'';
      }) (self.callPackage ./packages/cardano-addresses-cli.nix { cardano-address = null; });

      # cardano-base
      base-deriving-via = self.callPackage ./packages/base-deriving-via.nix { };
      cardano-binary = self.callPackage ./packages/cardano-binary.nix { };
      cardano-binary-test = self.callPackage ./packages/cardano-binary-test.nix { };
      cardano-crypto-class = addBuildDepend libsodium (self.callPackage ./packages/cardano-crypto-class.nix { });
      cardano-crypto-praos = appendConfigureFlags [ "-f" "-external-libsodium-vrf" ] (self.callPackage ./packages/cardano-crypto-praos.nix { });
      cardano-crypto-tests = self.callPackage ./packages/cardano-crypto-tests.nix { };
      cardano-slotting = self.callPackage ./packages/cardano-slotting.nix { };
      measures = self.callPackage ./packages/measures.nix { };
      orphans-deriving-via = self.callPackage ./packages/orphans-deriving-via.nix { };
      strict-containers = self.callPackage ./packages/strict-containers.nix { };

      # cardano-config
      cardano-config = self.callPackage ./packages/cardano-config.nix { };

      # cardano-crypto
      cardano-crypto = self.callPackage ./packages/cardano-crypto.nix { };

      # cardano-ledger
      byron-spec-chain = self.callPackage ./packages/byron-spec-chain.nix { };
      byron-spec-ledger = self.callPackage ./packages/byron-spec-ledger.nix { };
      cardano-crypto-test = self.callPackage ./packages/cardano-crypto-test.nix { };
      cardano-crypto-wrapper = self.callPackage ./packages/cardano-crypto-wrapper.nix { };
      cardano-data = self.callPackage ./packages/cardano-data.nix { };
      cardano-ledger-alonzo = self.callPackage ./packages/cardano-ledger-alonzo.nix { };
      cardano-ledger-byron = overrideCabal (drv: {
        jailbreak = true;
        preCheck = ''
          export CARDANO_MAINNET_MIRROR="${cardano-mainnet-mirror}/epochs"
        '';
      }) (self.callPackage ./packages/cardano-ledger-byron.nix { });
      cardano-ledger-byron-test = self.callPackage ./packages/cardano-ledger-byron-test.nix { };
      cardano-ledger-core = self.callPackage ./packages/cardano-ledger-core.nix { };
      cardano-ledger-pretty = self.callPackage ./packages/cardano-ledger-pretty.nix { };
      cardano-ledger-shelley = self.callPackage ./packages/cardano-ledger-shelley.nix { };
      cardano-ledger-shelley-test = overrideCabal (drv: {
        testToolDepends = (drv.testToolDepends or []) ++ [ cddl cbor-diag ];
        testFlags = [
          "-p" "!/ShelleyGenesis JSON golden test/"
        ];
      }) (self.callPackage ./packages/cardano-ledger-shelley-test.nix { });
      cardano-ledger-shelley-ma = self.callPackage ./packages/cardano-ledger-shelley-ma.nix { };
      cardano-protocol-tpraos = self.callPackage ./packages/cardano-protocol-tpraos.nix { };
      compact-map = self.callPackage ./packages/compact-map.nix { };
      non-integral = self.callPackage ./packages/non-integral.nix { };
      set-algebra = self.callPackage ./packages/set-algebra.nix { };
      small-steps = self.callPackage ./packages/small-steps.nix { };
      small-steps-test = self.callPackage ./packages/small-steps-test.nix { };

      # cardano-node
      cardano-api = overrideCabal (drv: {
        jailbreak = true;
      }) (self.callPackage ./packages/cardano-api.nix { });
      cardano-cli = dontCheck (self.callPackage ./packages/cardano-cli.nix { }); # cabal cannot find library cardano-api:gen
      cardano-node = overrideCabal (drv: {
        jailbreak = true;
      }) (self.callPackage ./packages/cardano-node.nix { });

      # cardano-prelude
      cardano-prelude = self.callPackage ./packages/cardano-prelude.nix { };
      cardano-prelude-test = self.callPackage ./packages/cardano-prelude-test.nix { };

      # cardano-sl-x509
      cardano-sl-x509 = self.callPackage ./packages/cardano-sl-x509.nix { };

      # cardano-wallet
      cardano-numeric = self.callPackage ./packages/cardano-numeric.nix { };
      cardano-wallet = overrideCabal (drv: {
        testToolDepends = (drv.testToolDepends or []) ++ [ self.cardano-cli self.cardano-node ];
        preCheck = ''export PATH="$PWD/dist/build/cardano-wallet:$PATH"'';
      }) (self.callPackage ./packages/cardano-wallet.nix { });
      cardano-wallet-cli = self.callPackage ./packages/cardano-wallet-cli.nix { };
      cardano-wallet-core = doJailbreak (dontCheck (self.callPackage ./packages/cardano-wallet-core.nix { }));
      cardano-wallet-core-integration = self.callPackage ./packages/cardano-wallet-core-integration.nix { };
      cardano-wallet-launcher = self.callPackage ./packages/cardano-wallet-launcher.nix { };
      cardano-wallet-test-utils = self.callPackage ./packages/cardano-wallet-test-utils.nix { };
      dbvar = self.callPackage ./packages/dbvar.nix { };
      strict-non-empty-containers = self.callPackage ./packages/strict-non-empty-containers.nix { };
      text-class = self.callPackage ./packages/text-class.nix { };

      # goblins
      goblins = self.callPackage ./packages/goblins.nix { };

      # hedgehog-extras
      hedgehog-extras = doJailbreak (self.callPackage ./packages/hedgehog-extras.nix { }); # aeson 1.5.5.1

      # iohk-monitoring-framework
      contra-tracer = self.callPackage ./packages/contra-tracer.nix { };
      iohk-monitoring = overrideCabal (drv: {
        testFlags = [
          "-p" "!(/parsed representation/||/static representation/)"
        ];
      }) (self.callPackage ./packages/iohk-monitoring.nix { });
      lobemo-backend-aggregation = self.callPackage ./packages/lobemo-backend-aggregation.nix { };
      lobemo-backend-ekg = self.callPackage ./packages/lobemo-backend-ekg.nix { };
      lobemo-backend-monitoring = self.callPackage ./packages/lobemo-backend-monitoring.nix { };
      lobemo-backend-trace-forwarder = self.callPackage ./packages/lobemo-backend-trace-forwarder.nix { };
      lobemo-scribe-systemd = self.callPackage ./packages/lobemo-scribe-systemd.nix { };
      tracer-transformers = self.callPackage ./packages/tracer-transformers.nix { };

      # optparse-applicative
      optparse-applicative-fork = dontCheck (self.callPackage ./packages/optparse-applicative-fork.nix { });

      # ouroboros-network
      io-classes = self.callPackage ./packages/io-classes.nix { };
      io-sim = self.callPackage ./packages/io-sim.nix { };
      monoidal-synchronisation = self.callPackage ./packages/monoidal-synchronisation.nix { };
      ntp-client = self.callPackage ./packages/ntp-client.nix { };
      network-mux = self.callPackage ./packages/network-mux.nix { };
      ouroboros-consensus = doJailbreak (self.callPackage ./packages/ouroboros-consensus.nix { });
      ouroboros-consensus-byron = doJailbreak (self.callPackage ./packages/ouroboros-consensus-byron.nix { cryptonite = super.cryptonite_0_27; });
      ouroboros-consensus-cardano = self.callPackage ./packages/ouroboros-consensus-cardano.nix { };
      ouroboros-consensus-protocol = self.callPackage ./packages/ouroboros-consensus-protocol.nix { };
      ouroboros-consensus-shelley = self.callPackage ./packages/ouroboros-consensus-shelley.nix { };
      ouroboros-network = addTestToolDepends [
        cddl
        cbor-diag
      ] (self.callPackage ./packages/ouroboros-network.nix { });
      ouroboros-network-framework = doJailbreak (self.callPackage ./packages/ouroboros-network-framework.nix { });
      ouroboros-network-testing = self.callPackage ./packages/ouroboros-network-testing.nix { };
      strict-stm = self.callPackage ./packages/strict-stm.nix { };
      typed-protocols = self.callPackage ./packages/typed-protocols.nix { };
      typed-protocols-cborg = self.callPackage ./packages/typed-protocols-cborg.nix { };
      typed-protocols-examples = self.callPackage ./packages/typed-protocols-examples.nix { };

      # plutus
      plutus-core = doJailbreak (self.callPackage ./packages/plutus-core.nix { ral = super.ral_0_1; });
      plutus-ledger-api = self.callPackage ./packages/plutus-ledger-api.nix { };
      plutus-tx = self.callPackage ./packages/plutus-tx.nix { };
      prettyprinter-configurable = self.callPackage ./packages/prettyprinter-configurable.nix { };
      word-array = self.callPackage ./packages/word-array.nix { };

      # Win32-network
      Win32-network = self.callPackage ./packages/Win32-network.nix { };

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
