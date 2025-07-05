{
  lib,
  stdenv,
  python3,
  bash,
  ipmitool,
  smartmontools,
  hddtemp,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "smfc";
  version = "3.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "petersulyok";
    repo = "smfc";
    rev = "v${version}";
    hash = "sha256-huuibfcvY0Bua0g1desUyFaPyi1y4EyYPWRR+xt/iYA=";
  };

  buildInputs = [
    bash
    ipmitool
    python3
    hddtemp
    smartmontools
  ];

  passthru.updateScript = nix-update-script { };

  installPhase = ''
    mkdir -p $out/bin
    install src/smfc.py $out/bin/smfc
    cp ipmi/*.sh $out/bin
    substituteInPlace $out/bin/fan_measurement.sh --replace "./set_ipmi_fan_level.sh" "$out/bin/set_ipmi_fan_level.sh"
    for fn in `ls  $out/bin/*.sh`; do
      substituteInPlace $fn --replace "ipmitool" "${ipmitool}/bin/ipmitool"
    done
    substituteInPlace $out/bin/smfc --replace "/usr/sbin/smartctl" "${smartmontools}/bin/smartctl" --replace "/usr/sbin/hddtemp" "${hddtemp}/bin/hddtemp" --replace "/usr/bin/ipmitool" "${ipmitool}/bin/ipmitool"
  '';

  meta = with lib; {
    description = "Super Micro Fan Control";
    homepage = "https://github.com/petersulyok/smfc/tree/main";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ poelzi ];
    mainProgram = "smfc";
  };
}
