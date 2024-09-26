{ lib
, python3
, fetchFromGitHub
, ethtool
, dmidecode
, ipmitool
, lldpd
, lshw
}:

python3.pkgs.buildPythonApplication rec {
  pname = "netbox-agent";
  version = "unstable-2023-03-19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Solvik";
    repo = "netbox-agent";
    rev = "master";
    hash = "sha256-lkC5UZFEN78GIbE5m6/c9iEYkynWZh+S5Kn0CuKisuM=";
  };

  patches = [
    ./lshw.patch # https://github.com/Solvik/netbox-agent/pull/292
    ./vm_tags.patch # https://github.com/Solvik/netbox-agent/pull/293
    ./role.patch # https://github.com/Solvik/netbox-agent/pull/289
    ./return-code.patch # From https://github.com/Solvik/netbox-agent/pull/279
  ];

  postPatch = ''
    # remove legacy code
    echo "" > netbox_agent/__init__.py
  '';

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
    python3.pkgs.pythonRelaxDepsHook
  ];
  pythonRelaxDeps = true;

  propagatedBuildInputs = with python3.pkgs; [
    distro
    jsonargparse
    netaddr
    netifaces
    packaging
    pynetbox
    python-slugify
    pyyaml
  ];

  postInstall = ''
    wrapProgram $out/bin/netbox_agent \
      --prefix PATH ":" ${lib.makeBinPath [
        ethtool
        dmidecode
        ipmitool
        lldpd
        lshw
      ]}
  '';

  pythonImportsCheck = [ "netbox_agent" ];

  meta = with lib; {
    description = "Netbox agent to run on your infrastructure's servers";
    homepage = "https://github.com/Solvik/netbox-agent";
    license = licenses.asl20;
    maintainers = with maintainers; [ sinavir raitobezarius ];
    mainProgram = "netbox_agent";
  };
}
