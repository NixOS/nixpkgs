#!/usr/bin/env nix-shell
#!nix-shell -p cabal2nix -i bash -I nixpkgs=../../../../../

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 PROJECT_NAME REVISION"
    echo "e.g.   $0 cardano-wallet v2022-01-18"
    exit 1
fi

REVISION=$2
PROJECT_NAME=$1

case $PROJECT_NAME in
    "cardano-addresses")
        PACKAGES=(
            "command-line" "cardano-addresses-cli"
            "core" "cardano-addresses"
            "jsapi" "cardano-addresses-jsapi"
            "jsbits" "cardano-addresses-jsbits"
        )
        ;;

    "cardano-base")
        PACKAGES=(
            "base-deriving-via" "base-deriving-via"
            "binary" "cardano-binary"
            "binary/test" "cardano-binary-test"
            "cardano-crypto-class" "cardano-crypto-class"
            "cardano-crypto-praos" "cardano-crypto-praos"
            "cardano-crypto-tests" "cardano-crypto-tests"
            "measures" "measures"
            "orphans-deriving-via" "orphans-deriving-via"
            "slotting" "cardano-slotting"
            "strict-containers" "strict-containers"
        )
        ;;

    "cardano-config")
        PACKAGES=(
            "." "cardano-config"
        )
        ;;

    "cardano-crypto")
        PACKAGES=(
            "." "cardano-crypto"
        )
        ;;

    "cardano-ledger")
        PACKAGES=(
            "eras/alonzo/impl" "cardano-ledger-alonzo"
            "eras/alonzo/test-suite" "cardano-ledger-alonzo-test"
            # "eras/babbage/impl" "cardano-ledger-babbage"
            "eras/byron/chain/executable-spec" "byron-spec-chain"
            "eras/byron/crypto/test" "cardano-crypto-test"
            "eras/byron/crypto" "cardano-crypto-wrapper"
            "eras/byron/ledger/executable-spec" "byron-spec-ledger"
            "eras/byron/ledger/impl" "cardano-ledger-byron"
            "eras/byron/ledger/impl/test" "cardano-ledger-byron-test"
            "eras/shelley-ma/impl" "cardano-ledger-shelley-ma"
            "eras/shelley-ma/test-suite" "cardano-ledger-shelley-ma-test"
            "eras/shelley/impl" "cardano-ledger-shelley"
            "eras/shelley/test-suite" "cardano-ledger-shelley-test"
            "libs/cardano-data" "cardano-data"
            "libs/cardano-ledger-core" "cardano-ledger-core"
            "libs/cardano-ledger-example-shelley" "cardano-ledger-example-shelley"
            "libs/cardano-ledger-pretty" "cardano-ledger-pretty"
            "libs/cardano-ledger-test" "cardano-ledger-test"
            "libs/cardano-protocol-tpraos" "cardano-protocol-tpraos"
            "libs/compact-map" "compact-map"
            "libs/ledger-state" "ledger-state"
            "libs/non-integral" "non-integral"
            "libs/plutus-preprocessor" "plutus-preprocessor"
            "libs/set-algebra" "set-algebra"
            "libs/small-steps-test" "small-steps-test"
            "libs/small-steps" "small-steps"
        )
        ;;

    "cardano-node")
        PACKAGES=(
            "cardano-api" "cardano-api"
            "cardano-cli" "cardano-cli"
            "cardano-client-demo" "cardano-client-demo"
            # "cardano-git-rev" "cardano-git-rev"
            # "cardano-node-capi" "cardano-node-capi"
            "cardano-node-chairman" "cardano-node-chairman"
            "cardano-node" "cardano-node"
            "cardano-submit-api" "cardano-submit-api"
            "cardano-testnet" "cardano-testnet"
            # "cardano-tracer" "cardano-tracer"
            "plutus-example" "plutus-example"
            "trace-dispatcher" "trace-dispatcher"
            "trace-forward" "trace-forward"
            "trace-resources" "trace-resources"
        )
        ;;

    "cardano-prelude")
        PACKAGES=(
            "cardano-prelude-test" "cardano-prelude-test"
            "cardano-prelude" "cardano-prelude"
        )
        ;;

    "cardano-sl-x509")
        PACKAGES=(
            "." "cardano-sl-x509"
        )
        ;;

    "cardano-wallet")
        PACKAGES=(
            "lib/cli" "cardano-wallet-cli"
            "lib/core" "cardano-wallet-core"
            "lib/core-integration" "cardano-wallet-core-integration"
            "lib/dbvar" "dbvar"
            "lib/launcher" "cardano-wallet-launcher"
            "lib/numeric" "cardano-numeric"
            "lib/shelley" "cardano-wallet"
            "lib/strict-non-empty-containers" "strict-non-empty-containers"
            "lib/test-utils" "cardano-wallet-test-utils"
            "lib/text-class" "text-class"
        )
        ;;

    "goblins")
        PACKAGES=(
            "." "goblins"
        )
        ;;

    "hedgehog-extras")
        PACKAGES=(
            "." "hedgehog-extras"
        )
        ;;

    "iohk-monitoring-framework")
        PACKAGES=(
            "contra-tracer" "contra-tracer"
            "examples" "lobemo-examples"
            "iohk-monitoring" "iohk-monitoring"
            "plugins/backend-aggregation" "lobemo-backend-aggregation"
            "plugins/backend-editor" "lobemo-backend-editor"
            "plugins/backend-ekg" "lobemo-backend-ekg"
            "plugins/backend-graylog" "lobemo-backend-graylog"
            "plugins/backend-monitoring" "lobemo-backend-monitoring"
            "plugins/backend-trace-acceptor" "lobemo-backend-trace-acceptor"
            "plugins/backend-trace-forwarder" "lobemo-backend-trace-forwarder"
            "plugins/scribe-systemd" "lobemo-scribe-systemd"
            "tracer-transformers" "tracer-transformers"
        )
        ;;

    "optparse-applicative")
        PACKAGES=(
            "." "optparse-applicative-fork"
        )
        ;;

    "ouroboros-network")
        PACKAGES=(
            "cardano-client" "cardano-client"
            "io-classes" "io-classes"
            "io-sim" "io-sim"
            "monoidal-synchronisation" "monoidal-synchronisation"
            "network-mux" "network-mux"
            "ntp-client" "ntp-client"
            "ouroboros-consensus-byron-test" "ouroboros-consensus-byron-test"
            "ouroboros-consensus-byron" "ouroboros-consensus-byron"
            "ouroboros-consensus-byronspec" "ouroboros-consensus-byronspec"
            "ouroboros-consensus-cardano-test" "ouroboros-consensus-cardano-test"
            "ouroboros-consensus-cardano" "ouroboros-consensus-cardano"
            "ouroboros-consensus-mock-test" "ouroboros-consensus-mock-test"
            "ouroboros-consensus-mock" "ouroboros-consensus-mock"
            "ouroboros-consensus-protocol" "ouroboros-consensus-protocol"
            "ouroboros-consensus-shelley-test" "ouroboros-consensus-shelley-test"
            "ouroboros-consensus-shelley" "ouroboros-consensus-shelley"
            "ouroboros-consensus-test" "ouroboros-consensus-test"
            "ouroboros-consensus" "ouroboros-consensus"
            "ouroboros-network-framework" "ouroboros-network-framework"
            "ouroboros-network-testing" "ouroboros-network-testing"
            "ouroboros-network" "ouroboros-network"
            "strict-stm" "strict-stm"
            "typed-protocols-cborg" "typed-protocols-cborg"
            "typed-protocols-examples" "typed-protocols-examples"
            "typed-protocols" "typed-protocols"
        )
        ;;

    "plutus")
        PACKAGES=(
            "fake-pab" "fake-pab"
            "freer-extras" "freer-extras"
            "marlowe-actus" "marlowe-actus"
            "marlowe-dashboard-server" "marlowe-dashboard-server"
            "marlowe-playground-server" "marlowe-playground-server"
            "marlowe-symbolic" "marlowe-symbolic"
            "marlowe" "marlowe"
            "playground-common" "playground-common"
            "plutus-benchmark" "plutus-benchmark"
            "plutus-chain-index" "plutus-chain-index"
            "plutus-contract" "plutus-contract"
            "plutus-core" "plutus-core"
            "plutus-errors" "plutus-errors"
            "plutus-ledger-api" "plutus-ledger-api"
            "plutus-ledger" "plutus-ledger"
            "plutus-metatheory" "plutus-metatheory"
            "plutus-pab" "plutus-pab"
            "plutus-playground-server" "plutus-playground-server"
            "plutus-tx-plugin" "plutus-tx-plugin"
            "plutus-tx" "plutus-tx"
            "plutus-use-cases" "plutus-use-cases"
            "prettyprinter-configurable" "prettyprinter-configurable"
            "quickcheck-dynamic" "quickcheck-dynamic"
            "stubs/plutus-ghc-stub" "plutus-ghc-stub"
            "web-ghc" "web-ghc"
            "word-array" "word-array"
        )
        ;;

    "Win32-network")
        PACKAGES=(
            "." "Win32-network"
        )
        ;;

    *)
        echo "invalid project name"
        exit 1
        ;;
esac

for (( i=0 ; i<${#PACKAGES[@]} ; i+=2 ))
do
    cabal2nix https://github.com/input-output-hk/$PROJECT_NAME/ --revision $REVISION --subpath ${PACKAGES[i]} > ${PACKAGES[i+1]}.nix
done
