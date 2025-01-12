set -euo pipefail

mkdir /tmp/tutorial-scion-certs && cd /tmp/tutorial-scion-certs
mkdir AS{1..5}

# Create voting and root keys and (self-signed) certificates for core ASes
pushd AS1
scion-pki certificate create --not-after=3650d --profile=sensitive-voting <(echo '{"isd_as": "42-ffaa:1:1", "common_name": "42-ffaa:1:1 sensitive voting cert"}') sensitive-voting.pem sensitive-voting.key
scion-pki certificate create --not-after=3650d --profile=regular-voting <(echo '{"isd_as": "42-ffaa:1:1", "common_name": "42-ffaa:1:1 regular voting cert"}') regular-voting.pem regular-voting.key
scion-pki certificate create --not-after=3650d --profile=cp-root <(echo '{"isd_as": "42-ffaa:1:1", "common_name": "42-ffaa:1:1 cp root cert"}') cp-root.pem cp-root.key
popd

pushd AS2
scion-pki certificate create --not-after=3650d --profile=cp-root <(echo '{"isd_as": "42-ffaa:1:2", "common_name": "42-ffaa:1:2 cp root cert"}') cp-root.pem cp-root.key
popd

pushd AS3
scion-pki certificate create --not-after=3650d --profile=sensitive-voting <(echo '{"isd_as": "42-ffaa:1:3", "common_name": "42-ffaa:1:3 sensitive voting cert"}') sensitive-voting.pem sensitive-voting.key
scion-pki certificate create --not-after=3650d --profile=regular-voting <(echo '{"isd_as": "42-ffaa:1:3", "common_name": "42-ffaa:1:3 regular voting cert"}') regular-voting.pem regular-voting.key
popd

# Create the TRC (Trust Root Configuration)
mkdir tmp
echo '
isd = 42
description = "Demo ISD 42"
serial_version = 1
base_version = 1
voting_quorum = 2

core_ases = ["ffaa:1:1", "ffaa:1:2", "ffaa:1:3"]
authoritative_ases = ["ffaa:1:1", "ffaa:1:2", "ffaa:1:3"]
cert_files = ["AS1/sensitive-voting.pem", "AS1/regular-voting.pem", "AS1/cp-root.pem", "AS2/cp-root.pem", "AS3/sensitive-voting.pem", "AS3/regular-voting.pem"]

[validity]
not_before = '$(date +%s)'
validity = "365d"' \
> trc-B1-S1-pld.tmpl

scion-pki trc payload --out=tmp/ISD42-B1-S1.pld.der --template trc-B1-S1-pld.tmpl
rm trc-B1-S1-pld.tmpl

# Sign and bundle the TRC
scion-pki trc sign tmp/ISD42-B1-S1.pld.der AS1/sensitive-voting.{pem,key} --out tmp/ISD42-B1-S1.AS1-sensitive.trc
scion-pki trc sign tmp/ISD42-B1-S1.pld.der AS1/regular-voting.{pem,key} --out tmp/ISD42-B1-S1.AS1-regular.trc
scion-pki trc sign tmp/ISD42-B1-S1.pld.der AS3/sensitive-voting.{pem,key} --out tmp/ISD42-B1-S1.AS3-sensitive.trc
scion-pki trc sign tmp/ISD42-B1-S1.pld.der AS3/regular-voting.{pem,key} --out tmp/ISD42-B1-S1.AS3-regular.trc

scion-pki trc combine tmp/ISD42-B1-S1.AS{1,3}-{sensitive,regular}.trc --payload tmp/ISD42-B1-S1.pld.der --out ISD42-B1-S1.trc
rm tmp -r

# Create CA key and certificate for issuing ASes
pushd AS1
scion-pki certificate create --profile=cp-ca <(echo '{"isd_as": "42-ffaa:1:1", "common_name": "42-ffaa:1:1 CA cert"}') cp-ca.pem cp-ca.key --ca cp-root.pem --ca-key cp-root.key
popd
pushd AS2
scion-pki certificate create --profile=cp-ca <(echo '{"isd_as": "42-ffaa:1:2", "common_name": "42-ffaa:1:2 CA cert"}') cp-ca.pem cp-ca.key --ca cp-root.pem --ca-key cp-root.key
popd

# Create AS key and certificate chains
scion-pki certificate create --profile=cp-as <(echo '{"isd_as": "42-ffaa:1:1", "common_name": "42-ffaa:1:1 AS cert"}') AS1/cp-as.pem AS1/cp-as.key --ca AS1/cp-ca.pem --ca-key AS1/cp-ca.key --bundle
scion-pki certificate create --profile=cp-as <(echo '{"isd_as": "42-ffaa:1:2", "common_name": "42-ffaa:1:2 AS cert"}') AS2/cp-as.pem AS2/cp-as.key --ca AS2/cp-ca.pem --ca-key AS2/cp-ca.key --bundle
scion-pki certificate create --profile=cp-as <(echo '{"isd_as": "42-ffaa:1:3", "common_name": "42-ffaa:1:3 AS cert"}') AS3/cp-as.pem AS3/cp-as.key --ca AS1/cp-ca.pem --ca-key AS1/cp-ca.key --bundle
scion-pki certificate create --profile=cp-as <(echo '{"isd_as": "42-ffaa:1:4", "common_name": "42-ffaa:1:4 AS cert"}') AS4/cp-as.pem AS4/cp-as.key --ca AS1/cp-ca.pem --ca-key AS1/cp-ca.key --bundle
scion-pki certificate create --profile=cp-as <(echo '{"isd_as": "42-ffaa:1:5", "common_name": "42-ffaa:1:5 AS cert"}') AS5/cp-as.pem AS5/cp-as.key --ca AS2/cp-ca.pem --ca-key AS2/cp-ca.key --bundle

for i in {1..5}
do
  mkdir -p $out/AS$i
  cp AS$i/cp-as.{key,pem} $out/AS$i
done

mv *.trc $out
