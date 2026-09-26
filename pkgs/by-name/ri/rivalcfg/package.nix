{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "rivalcfg";
  version = "4.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "flozz";
    repo = "rivalcfg";
    tag = "v${version}";
    sha256 = "sha256-MUbt8beVG6UjpLFqxGC8nTaSswvHN3PJ/jE28BBL8bs=";
  };

  build-system = with python3Packages; [ flit-core ];

  dependencies = with python3Packages; [
    hidapi
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  # tests are broken
  doCheck = false;

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    tmpl_udev="$out/lib/udev/rules.d/99-rivalcfg.rules"
    tmpudev="''${tmpl_udev}.in"
    finaludev="$tmpl_udev"
    "$out/bin/rivalcfg" --print-udev > "$tmpudev"
    substitute "$tmpudev" "$out/lib/udev/rules.d/99-rivalcfg.rules" \
      --replace-fail MODE=\"0666\" "MODE=\"0664\", GROUP=\"input\""
    rm "$tmpudev"
  '';

  pythonImportsCheck = [ "rivalcfg" ];

  meta = {
    description = "Utility program that allows you to configure SteelSeries Rival gaming mice";
    homepage = "https://github.com/flozz/rivalcfg";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ ornxka ];
    mainProgram = "rivalcfg";
  };
}
