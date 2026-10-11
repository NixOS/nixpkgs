{
  lib,
  python3Packages,
  bash,
  ipmitool,
  smartmontools,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "smfc";
  version = "4.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "petersulyok";
    repo = "smfc";
    tag = "v${version}";
    hash = "sha256-z5SYjo6c8gXaG4Ez/Fd6RzTnGj5EloRa3NbFfKh8+qw=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.pyudev ];

  postInstall = ''
    cp ipmi/*.sh $out/bin
    substituteInPlace $out/bin/fan_measurement.sh \
      --replace-fail "./set_ipmi_fan_level.sh" "$out/bin/set_ipmi_fan_level.sh"
    for fn in $out/bin/*.sh; do
      substituteInPlace $fn \
        --replace-fail "ipmitool" "${lib.getExe ipmitool}"
    done
  '';

  nativeCheckInputs = [
    bash
    ipmitool
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Super Micro Fan Control";
    homepage = "https://github.com/petersulyok/smfc";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ poelzi ];
    mainProgram = "smfc";
  };
}
