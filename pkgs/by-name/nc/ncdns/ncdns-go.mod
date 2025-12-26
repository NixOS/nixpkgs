module github.com/namecoin/ncdns

go 1.22.5

replace github.com/namecoin/x509-compressed => ./x509
replace gopkg.in/alecthomas/kingpin.v2 => github.com/alecthomas/kingpin/v2 v2.3.2

require (
  github.com/btcsuite/btcd v0.24.2
  github.com/fxamacker/cbor v1.5.1
  github.com/golang/groupcache v0.0.0-20210331224755-41bb18bfe9da
  github.com/hlandau/buildinfo v0.0.0-20161112115716-337a29b54997
  github.com/hlandau/degoutils v0.0.0-20161011040956-8fa2440b6344
  github.com/hlandau/dexlogconfig v0.0.0-20220319061854-86a3fc314fe7
  github.com/hlandau/nctestsuite v0.0.0-20151129185958-a9b78806c85c
  github.com/hlandau/xlog v1.0.0
  github.com/kr/pretty v0.3.1
  github.com/miekg/dns v1.1.61
  github.com/namecoin/certinject v0.1.1
  github.com/namecoin/ncbtcjson v0.1.0
  github.com/namecoin/ncrpcclient v0.1.0
  github.com/namecoin/splicesign v0.0.1
  github.com/namecoin/tlsrestrictnss v0.0.5
  github.com/namecoin/x509-compressed v0.0.0-00010101000000-000000000000
  gopkg.in/hlandau/easyconfig.v1 v1.0.18
  gopkg.in/hlandau/madns.v2 v2.0.2
  gopkg.in/hlandau/service.v2 v2.0.17
)
require (
  github.com/BurntSushi/toml v1.4.0 // indirect
  github.com/alecthomas/units v0.0.0-20211218093645-b94a6e3cc137 // indirect
  github.com/btcsuite/btcd/btcec/v2 v2.1.3 // indirect
  github.com/btcsuite/btcd/btcutil v1.1.5 // indirect
  github.com/btcsuite/btcd/chaincfg/chainhash v1.1.0 // indirect
  github.com/btcsuite/btclog v0.0.0-20170628155309-84c8d2346e9f // indirect
  github.com/btcsuite/go-socks v0.0.0-20170105172521-4720035b7bfd // indirect
  github.com/btcsuite/websocket v0.0.0-20150119174127-31079b680792 // indirect
  github.com/coreos/go-systemd v0.0.0-20191104093116-d3cd4ed1dbcf // indirect
  github.com/decred/dcrd/crypto/blake256 v1.0.0 // indirect
  github.com/decred/dcrd/dcrec/secp256k1/v4 v4.0.1 // indirect
  github.com/erikdubbelboer/gspt v0.0.0-20210805194459-ce36a5128377 // indirect
  github.com/kr/text v0.2.0 // indirect
  github.com/mattn/go-isatty v0.0.20 // indirect
  github.com/namecoin/crosssignnameconstraint v0.0.3 // indirect
  github.com/ogier/pflag v0.0.1 // indirect
  github.com/rogpeppe/go-internal v1.9.0 // indirect
  github.com/shiena/ansicolor v0.0.0-20230509054315-a9deabde6e02 // indirect
  github.com/x448/float16 v0.8.4 // indirect
  github.com/xhit/go-str2duration/v2 v2.1.0 // indirect
  golang.org/x/crypto v0.25.0 // indirect
  golang.org/x/mod v0.18.0 // indirect
  golang.org/x/net v0.26.0 // indirect
  golang.org/x/sync v0.7.0 // indirect
  golang.org/x/sys v0.22.0 // indirect
  golang.org/x/tools v0.22.0 // indirect
  gopkg.in/alecthomas/kingpin.v2 v2.0.0-00010101000000-000000000000 // indirect
  gopkg.in/hlandau/configurable.v1 v1.0.1 // indirect
  gopkg.in/hlandau/svcutils.v1 v1.0.11 // indirect
)
