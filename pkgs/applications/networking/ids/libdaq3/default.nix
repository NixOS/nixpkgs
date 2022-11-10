{ lib
, clangStdenv
, fetchFromGitHub
, autoreconfHook
, flex
, bison
, pkg-config
, cmocka
, file
, writeScript

, doCheck ? false # tests fail

# Optional dependencies
, withPcap ? true
, libpcap
, withNfq ? true
, libmnl
, libnfnetlink
, libnetfilter_queue
}:

with lib;

let
  pname = "libdaq3";
  version = "v3.0.9";

  optionalDeps = [
    { enabled = withPcap; deps = [ libpcap ]; } # modules: pcap, bpf, dump
    { enabled = withNfq; deps = [ libmnl libnfnetlink libnetfilter_queue ]; } # modules: nfq
  ];
in
clangStdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "snort3";
    repo = "libdaq";
    rev = version;
    sha256 = "Vol0Qd6xtep7nZNwZbJyWvPv25XFiJOlxZ7MJVa+VA4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    flex
    bison
    pkg-config
  ];

  checkInputs = [
    cmocka
  ];

  buildInputs = concatMap (f: optionals f.enabled f.deps) (filter (f: f ? deps) optionalDeps);

  preConfigure = ''
    patchShebangs ./configure
    substituteInPlace ./configure \
      --replace "/usr/bin/file" "${file}/bin/file"
  '';

  preAutoreconf = "./bootstrap";

  enableParallelBuilding = true;

  fixupPhase = ''
    patchelf $out/bin/daqtest-static
  '';

  inherit doCheck;

  passthru = {
    updateScript = writeScript "update.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq common-updater-scripts

      set -euo pipefail

      version=$(curl --silent "https://api.github.com/repos/snort3/libdaq/releases/latest" | jq -r .tag_name)
      update-source-version "${pname}" "$version"
    '';
  };

  meta = {
    description = "Data AcQuisition library (DAQ), for packet I/O";
    homepage = "https://www.snort.org";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ zzschmidc ];
    platforms = platforms.linux;
  };
}
