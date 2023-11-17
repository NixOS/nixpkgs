{ fetchFromGitHub,
  findutils,
  gnugrep,
  gnused,
  iproute2,
  iptables,
  lib,
  nettools, # for hostname
  openssh,
  openssl,
  parted,
  procps, # for pidof,
  python39, # the latest python version that waagent test against according to https://github.com/Azure/WALinuxAgent/blob/28345a55f9b21dae89472111635fd6e41809d958/.github/workflows/ci_pr.yml#L75
  shadow, # for useradd, usermod
  util-linux, # for (u)mount, fdisk, sfdisk, mkswap
}:

let
  inherit (lib) makeBinPath;

in
python39.pkgs.buildPythonPackage rec {
  pname = "waagent";
  version = "2.8.0.11";
  src = fetchFromGitHub {
    owner = "Azure";
    repo = "WALinuxAgent";
    rev = "04ded9f0b708cfaf4f9b68eead1aef4cc4f32eeb";
    sha256 = "0fvjanvsz1zyzhbjr2alq5fnld43mdd776r2qid5jy5glzv0xbhf";
  };
  patches = [
    # Suppress the following error when waagent try to configure sshd:
    # Read-only file system: '/etc/ssh/sshd_config'
    ./dont-configure-sshd.patch
  ];
  doCheck = false;

  buildInputs = with python39.pkgs; [ distro ];
  runtimeDeps = [
    findutils
    gnugrep
    gnused
    iproute2
    iptables
    nettools # for hostname
    openssh
    openssl
    parted
    procps # for pidof
    shadow # for useradd, usermod
    util-linux # for (u)mount, fdisk, sfdisk, mkswap
  ];

  fixupPhase = ''
     mkdir -p $out/bin/
     WAAGENT=$(find $out -name waagent | grep sbin)
     cp $WAAGENT $out/bin/waagent
     wrapProgram "$out/bin/waagent" \
         --prefix PYTHONPATH : $PYTHONPATH \
         --prefix PATH : "${makeBinPath runtimeDeps}"
     patchShebangs --build "$out/bin/"
  '';

  meta = {
    description = "The Microsoft Azure Linux Agent (waagent)
                   manages Linux provisioning and VM interaction with the Azure
                   Fabric Controller";
    homepage = "https://github.com/Azure/WALinuxAgent";
    license = with lib.licenses; [ asl20 ];
  };

}
